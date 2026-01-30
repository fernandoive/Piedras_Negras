import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:data_analitica_2/models/gps_model.dart';
import 'package:http/http.dart' as http;

class Services{

  final scheme = 'https';

  final headers = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<http.Response> addEncuesta({
    required Formulario formulario
  }) async {
      Timer? timeoutTimer;
      try{
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        final completer = Completer<http.Response>();
        
        timeoutTimer = Timer(const Duration(seconds: 10), () {
        client.close(force: true); // aborta conexiones activas
        if (!completer.isCompleted) {
            completer.complete(http.Response('timeout', 408));
          }
        });
        await http.post(
          Uri.parse('https://api.pn2026.dataanalitica.net/addEncuesta'), 
          body: formulario.toSend()
        ).then((res) {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(res);
        }
      }).catchError((e) {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      });
      return completer.future;      
      } else {
        return http.Response('error', 408);
      }
    } finally {
      timeoutTimer?.cancel();
    }
  }

  Future<http.Response> updateCall({
    required Map<String, dynamic> data,
    required int id
  }) async {
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        return await http.put(
          Uri.parse('https://api.pn2026.dataanalitica.net/updateCallcenter/$id'), 
          body: data
        );
      } else {
        return http.Response('error', 408);
      }
  }

  Future<http.Response> addCoordenada({
    required GPSModel gpsModel
  }) async {
    return await http.post(Uri.parse('https://api.pn2026.dataanalitica.net/addTracking'), body: gpsModel.toMapCoordenada());
  }

  Future<http.Response> addCiudadanos({
    required Map<String, dynamic> data
  }) async {
    return await http.post(Uri.parse('https://api.pn2026.dataanalitica.net/addCiudadanos'), body: data);
  }

  Future<http.Response> addCall({
    required Map<String, dynamic> data
  }) async {
    return await http.post(Uri.parse('https://api.pn2026.dataanalitica.net/addCallcenter'), body: data);
  }

  Future<http.Response> addCheck({
    required Map<String, dynamic> data
  }) async {
    return await http.post(Uri.parse('https://api.pn2026.dataanalitica.net/addCheck'), body: data);
  }

  Future<http.Response> addLogs({
    required Map<String, dynamic> data
  }) async {
    return await http.post(Uri.parse('https://api.pn2026.dataanalitica.net/addLogApp'), body: data);
  }

  Future<http.Response> getEncuestaTotales({
    required String usuario
  }) async {
    return await http.get(Uri.parse('https://api.pn2026.dataanalitica.net/getEncuestaTotales/$usuario'));
  }

  Future<http.Response> getMensual({
    required String usuario
  }) async {
    return await http.get(Uri.parse('https://api.pn2026.dataanalitica.net/getTotalPorEncuestador/$usuario'));
  }

  Future<http.Response> getDiario({
    required String usuario
  }) async {
    return await http.get(Uri.parse('https://api.pn2026.dataanalitica.net/getTotalHoyPorEncuestador/$usuario'));
  }

  Future<http.Response> getUsers({
    required String seccion
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      var res = await http.post(
        Uri.parse('https://api.pn2026.dataanalitica.net/getCiudadanosXSeccion'),
        headers: headers,
        body: jsonEncode({'secciones': [int.parse(seccion)]})
        );
      return res;
    } else {
      return http.Response('error', 408);
    }
  }

  Future<http.Response> getCalls({
    required String seccion
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      var res = await http.post(
        Uri.parse('https://api.pn2026.dataanalitica.net/getCallcenterXSeccion'),
        headers: headers,
        body: jsonEncode({'secciones': [int.parse(seccion)]})
        );
      return res;
    } else {
      return http.Response('error', 408);
    }
  }

  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      return await http.post(
        Uri.parse('https://api.pn2026.dataanalitica.net/login_app'),
        body: {
          "correo": email,
          "contrasena": password 
        }
      );
    } else {
      return http.Response('error', 408);
    }
  }

  Future<http.Response> getColonias({
    required String seccion,
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      return await http.get(
        Uri.parse('https://api.pn2026.dataanalitica.net/getColoniasXSeccion/$seccion'),
      );
    } else {
      return http.Response('error', 408);
    }
  }

  Future<http.Response> getCercaSeccionalActiva({
    required String seccion,
    required String zona,
    required String fecha
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      return await http.post(
        Uri.parse('https://api.pn2026.dataanalitica.net/getCercaSeccionalActiva'),
        body: {
          "seccion": seccion,
          "zona": zona,
          "fecha": fecha
        }
      );
    } else {
      return http.Response('error', 408);
    }
  }

  Future<http.Response> verificar({
    required int id,
    required String secciones,
    required String observaciones,
    required String encuestador,
    required String urlAudio,
    required String verificar,
  }) async {
    var client = HttpClient();
    client.connectionTimeout = Duration(seconds: 10);
    var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
    var response = await request.close();
    if (response.statusCode == 200) {
      return await http.put(
        Uri.parse('https://api.pn2026.dataanalitica.net/VerificarCiudadano/$id'),
        body: {
          "secciones": secciones,
          "verificado": verificar,
          "observaciones": observaciones,
          "encuestador": encuestador,
          "urlAudio": urlAudio 
        }
      );
    } else {
      return http.Response('error', 408);
    }
  }
}