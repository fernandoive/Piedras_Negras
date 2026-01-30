import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:data_analitica_2/models/ciudadano_model.dart';
import 'package:data_analitica_2/models/data_call_model.dart';
import 'package:data_analitica_2/models/data_user_model.dart';
import 'package:data_analitica_2/models/gps_model.dart';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/home/bloc/detalles_bloc.dart';
import 'package:data_analitica_2/services/database/database.dart';
import 'package:data_analitica_2/services/services.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GPSServices {

  GPSServices._();
  static final GPSServices instance = GPSServices._();

  Future<void> addCoordenada({
    required GPSModel gpsModel,
  }) async {
    final Services services = Services();
    try{
      await services.addCoordenada(gpsModel: gpsModel).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response;
        }
      }).catchError((error) {});
    } catch (e) {}
  }

  Future<void> addCiudadanoSincronizar({
    required CiudadanoModel ciudadanoModel,
  }) async {
    final Services services = Services();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      var url = '';
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putFile(File(ciudadanoModel.urlAudio), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
        url = await (await uploadTask).ref.getDownloadURL();
      }
      CiudadanoModel data = ciudadanoModel;
      data.urlAudio = url;
      await services.addCiudadanos(data: data.toJson()).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response;
        }
      }).catchError((error) {});
    } catch (e) {}
  }

  Future<RespuestaUtilityModel> addCheck({
    required String type,
    required Uint8List image,
    required String latitud,
    required String longitud
  }) async {
    final Services services = Services();
      RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      var url = '';
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putData(image, firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
        url = await (await uploadTask).ref.getDownloadURL();
      }
      Map<String, dynamic> data = {
        'tipo': type,
        'urlFoto': url,
        'usuario': userModel.correo,
        'versionapp': version,
        'laltitud': latitud,
        'longitud': longitud
      };
      await services.addCheck(data: data).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response;
        }
      }).catchError((error) {});
    } catch (e) {
      if(e is SocketException) {
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = e.toString();
      }
      respuestaUtilityModel.error = true;
    }
    return respuestaUtilityModel;
  }

  Future<void> addLogs({
    required String accion,
    required String apartado,
    required String descripcion
  }) async {
    final Services services = Services();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      await services.addLogs(data: {
        "accion": accion,
        "usuario": userModel.correo,
        "apartado": apartado,
        "descripcion": descripcion,
        "version": version
      }).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response;
        }
      }).catchError((error) {});
    } catch (e) {}
  }

  Future<RespuestaUtilityModel> addCiudadanos({
    required DetallesBloc detallesBloc,
    required String urlAudio,
    required String seccion,
  }) async {
    final Services services = Services();
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    detallesBloc.mostrarCircularProgressNext(true);
    try{
      Location location = Location();
      LocationData? locationData;
      bool serviceEnabled = await location.serviceEnabled();
      if(!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if(serviceEnabled) {
        PermissionStatus permissionStatus = await location.hasPermission();
        if(permissionStatus == PermissionStatus.denied) {
          permissionStatus = await location.requestPermission();
          if(permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.grantedLimited) {
            locationData = await location.getLocation();
          } else {
            throw 'La ubicacion no esta activa';
          }
        } else {
          locationData = await location.getLocation();
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      var url = '';
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putFile(File(urlAudio), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
        url = await (await uploadTask).ref.getDownloadURL();
      }
      String distrito = '01';
      if(userModel.correo.contains('distrito')) {
        distrito = userModel.correo.substring(8, 10);
      }
      Map<String, dynamic> data = {
        "rol": detallesBloc.rolValue,
        "nombre": detallesBloc.nombreValue,
        "apellidoP": detallesBloc.apellidoPValue,
        "apellidoM": detallesBloc.apellidoMValue,
        "distrito": distrito,
        "municipio": detallesBloc.municipioValue,
        "seccion": seccion,
        "colonia": detallesBloc.coloniaValue,
        "calle": detallesBloc.calleValue,
        "num_ext": detallesBloc.numExtValue!.isEmpty ? "" : detallesBloc.numExtValue,
        "num_int": detallesBloc.numIntValue!.isEmpty ? "" : detallesBloc.numIntValue,
        "cp": detallesBloc.cpValue,
        "telefono": detallesBloc.telefonoValue,
        "dv": detallesBloc.dvValue,
        "mov": detallesBloc.movValue,
        "comite": detallesBloc.comiteValue,
        "cuantos": detallesBloc.cuantosValue,
        "latitud": locationData!.latitude.toString(),
        "longitud": locationData.longitude.toString(),
        "observaciones": detallesBloc.observacionesValue,
        "amigos_voluntarios": detallesBloc.amigosValue,
        "encuestador": userModel.correo,
        "versionapp": version,
        "urlAudio": url,
      };
      await services.addCiudadanos(
        data: data
      ).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response;
        }
      }).catchError((error) {});
    } catch (e) {
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'No fue posible verificar, revisa la conexion';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = 'Error $e';
      }
      respuestaUtilityModel.error = true;
    }
    detallesBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  }

  Future<void> getUsers({
    required String seccion
  }) async {
    final Services services = Services(); 
    try{
      await services.getUsers(seccion: seccion).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response.body;
        }
        Map<String, dynamic> userMap = jsonDecode(response.body);
        Users usersModel = Users.fromJson(userMap);
        if(usersModel.ciudadanos.isNotEmpty) {
          DatabaseProvider.db.deleteUsers();
          for (var element in usersModel.ciudadanos) {
            DatabaseProvider.db.registroUsers(element);
          }
        } else {
          DatabaseProvider.db.deleteUsers();
        }
        
      }).catchError((error) {
        throw error;
      });
    } catch (e) {}
  }

  Future<void> getCalls({
    required String seccion
  }) async {
    final Services services = Services(); 
    try{
      await services.getCalls(seccion: seccion).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response.body;
        }
        Map<String, dynamic> userMap = jsonDecode(response.body);
        DataCalls usersModel = DataCalls.fromJson(userMap);
        if(usersModel.registros.isNotEmpty) {
          DatabaseProvider.db.deleteCalls();
          for (var element in usersModel.registros) {
            DatabaseProvider.db.registroCalls(element);
          }
        } else {
          DatabaseProvider.db.deleteCalls();
        }
        
      }).catchError((error) {
        throw error;
      });
    } catch (e) {}
  }

  Future<RespuestaUtilityModel> verificar({
    required int id,
    required String secciones,
    required String observaciones,
    required String urlAudio,
    required String verificar,
    required DetallesBloc detallesBloc,
    required bool uploadFile,
    required bool callCenter,
    required DataUser data,
    required String duracion
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    detallesBloc.mostrarCircularProgressNext(true);
    final Services services = Services(); 
    try{
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      
      var url = '';
      if(uploadFile) {
        var client = HttpClient();
        client.connectionTimeout = Duration(seconds: 5);
        var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
        var response = await request.close();
        if (response.statusCode == 200) {
          final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
          firebase_storage.UploadTask? uploadTask;
          firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
          uploadTask = reference.putFile(File(urlAudio), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
          url = await (await uploadTask).ref.getDownloadURL();
        }
        if (response.statusCode == 200) {
          String distrito = '01';
          if(userModel.correo.contains('distrito')) {
            distrito = userModel.correo.substring(8, 10);
          }
          await services.addCall(
            data: {
              'distrito': distrito,
              'seccion': secciones, 
              'nombre': data.nombre, 
              'apellidoP': data.apellidoP,
              'apellidoM': data.apellidoM, 
              'municipio': data.municipio, 
              'telefono': data.telefono,
              'duracion': duracion, 
              'observaciones': observaciones,
              'versionapp': version,
          }).then((http.Response response) {}).catchError((error) {});
        }
      }
      await services.verificar(
        id: id,
        secciones: secciones,
        observaciones: observaciones,
        encuestador: userModel.correo,
        urlAudio: uploadFile ? url : urlAudio,
        verificar: verificar,
      ).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response.body;
        }
      }).catchError((error) {
        throw error;
      });
    } catch (e) {
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'No fue posible verificar, revisa la conexion';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = 'Error $e';
      }
      respuestaUtilityModel.error = true;
    }
    detallesBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  }
 
  Future<RespuestaUtilityModel> verificarSincronizar({
    required DataUser data
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    final Services services = Services(); 
    try{
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      
      var url = '';
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putFile(File(data.urlAudio), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
        url = await (await uploadTask).ref.getDownloadURL();
      }
      await services.verificar(
        id: int.parse(data.uid),
        secciones: data.seccion,
        observaciones: data.observaciones,
        encuestador: userModel.correo,
        urlAudio: url,
        verificar: data.verificado,
      ).then((http.Response response) {
        if(response.statusCode != 200) {
          throw response.body;
        }
      }).catchError((error) {
        throw error;
      });
    } catch (e) {
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'No fue posible verificar, revisa la conexion';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = 'Error $e';
      }
      respuestaUtilityModel.error = true;
    }
    return respuestaUtilityModel;
  }

  Future<RespuestaUtilityModel> verificarLocal({
    required String observaciones,
    required String urlAudio,
    required String verificar,
    required DetallesBloc detallesBloc,
    required DataUser data
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    detallesBloc.mostrarCircularProgressNext(true);
    try{
      DataUser dataUser = data;
      dataUser.urlAudio = urlAudio;
      dataUser.verificado = verificar;
      dataUser.observaciones = observaciones;
      await DatabaseProvider.db.registroVerificados(dataUser);
    } catch (e) {
      respuestaUtilityModel.mensaje = 'Error $e';
      respuestaUtilityModel.error = true;
    }
    detallesBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  }

  Future<RespuestaUtilityModel> ciudadanoLocal({
    required DetallesBloc detallesBloc,
    required String urlAudio,
    required String seccion,
    required String url
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    detallesBloc.mostrarCircularProgressNext(true);
    try{
      Location location = Location();
      LocationData? locationData;
      bool serviceEnabled = await location.serviceEnabled();
      if(!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if(serviceEnabled) {
        PermissionStatus permissionStatus = await location.hasPermission();
        if(permissionStatus == PermissionStatus.denied) {
          permissionStatus = await location.requestPermission();
          if(permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.grantedLimited) {
            locationData = await location.getLocation();
          } else {
            throw 'La ubicacion no esta activa';
          }
        } else {
          locationData = await location.getLocation();
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      String distrito = '01';
      if(userModel.correo.contains('distrito')) {
        distrito = userModel.correo.substring(8, 10);
      }
      Map<String, dynamic> data = {
        "rol": detallesBloc.rolValue,
        "nombre": detallesBloc.nombreValue,
        "apellidoP": detallesBloc.apellidoPValue,
        "apellidoM": detallesBloc.apellidoMValue,
        "distrito": distrito,
        "municipio": detallesBloc.municipioValue,
        "seccion": seccion,
        "colonia": detallesBloc.coloniaValue,
        "calle": detallesBloc.calleValue,
        "num_ext": detallesBloc.numExtValue!.isEmpty ? "" : detallesBloc.numExtValue,
        "num_int": detallesBloc.numIntValue!.isEmpty ? "" : detallesBloc.numIntValue,
        "cp": detallesBloc.cpValue,
        "telefono": detallesBloc.telefonoValue,
        "dv": detallesBloc.dvValue,
        "mov": detallesBloc.movValue,
        "comite": detallesBloc.comiteValue,
        "cuantos": detallesBloc.cuantosValue,
        "latitud": locationData!.latitude.toString(),
        "longitud": locationData.longitude.toString(),
        "observaciones": detallesBloc.observacionesValue,
        "amigos_voluntarios": detallesBloc.amigosValue,
        "encuestador": userModel.correo,
        "versionapp": version,
        "urlAudio": url,
      };
      await DatabaseProvider.db.registroCiudadano(data);
    } catch (e) {
      respuestaUtilityModel.mensaje = 'Error $e';
      respuestaUtilityModel.error = true;
    }
    detallesBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  }

  Future<RespuestaUtilityModel> updateCall({
    required int id,
    required int uid,
    required String observaciones,
    required DetallesBloc detallesBloc,
    required String duracion
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    detallesBloc.mostrarCircularProgressNext(true);
    final Services services = Services(); 
    try{
      await services.updateCall(
        id: uid,
        data: {
          'observaciones': observaciones,
          'duracion': duracion,
          'verificado': 'true'
        },
      ).then((http.Response response) async {
        if(response.statusCode != 200) {
          throw response.body;
        } else {
          await DatabaseProvider.db.deleteCall(id);
        }
      }).catchError((error) {
        throw error;
      });
    } catch (e) {
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'No fue posible verificar, revisa la conexion';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = 'Error $e';
      }
      respuestaUtilityModel.error = true;
    }
    detallesBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  }
}
