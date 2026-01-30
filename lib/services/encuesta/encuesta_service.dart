import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/models/seccion_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/models/colonia_model.dart';
import 'package:data_analitica_2/screens/encuesta/bloc/encuestado_bloc.dart';
import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:data_analitica_2/services/database/database.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/services/services.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class EncuestaServices {

  EncuestaServices._();
  static final EncuestaServices instance = EncuestaServices._();

  Future<RespuestaUtilityModel> encuestaLocal({
    required EncuestadoBloc encuestadoBloc,
    required Formulario form,
    required String? file,
    required String duracion,

  }) async {
    encuestadoBloc.mostrarCircularProgressNext(true);
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      final DateFormat date = DateFormat('yyyy-MM-dd HH:mm:ss');
      Formulario formulario = Formulario(
        createAt: date.format(DateTime.now()).toString(), 
        latitud: locationData!.latitude!, 
        longitud: locationData.longitude!,
        a: form.a, 
        b: form.b, 
        c: form.c, 
        d: form.d, 
        e: form.e, 
        f: form.f,
        g: form.g,
        h: form.h,
        i: form.i,
        j: form.j,
        k: form.k,
        nombre: encuestadoBloc.nameValue!, 
        apellidoPaterno: encuestadoBloc.apellidoPaternoValue!,
        apellidoMaterno: encuestadoBloc.apellidoMaternoValue!,
        telefono: encuestadoBloc.phoneValue!, 
        versionapp: version,
        uidUser: userModel.id.toString(),
        email: userModel.correo,
        urlAudio: file!,
        colonia: form.colonia!,
        calle: form.calle!,
        numero: form.numero,
        seccion: form.seccion,
        zona: form.zona,
        duracion: duracion
      );
      DatabaseProvider.db.registroEncuesta(formulario).then((value) {
      }).catchError((error) {
        if(error == 'La ubicacion no esta activa') {
          respuestaUtilityModel.mensaje = error;
        } else {
          respuestaUtilityModel.mensaje = 'Error, la encuesta no se guardo';
        }
        throw error;
      });
    
    } catch (e) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = respuestaUtilityModel.mensaje;
    }
    encuestadoBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  } 
  
  Future<RespuestaUtilityModel> encuestaFirebase({
    required EncuestadoBloc encuestadoBloc,
    required Formulario form,
    required String? file,
    required String duracion,
  }) async {
    encuestadoBloc.mostrarCircularProgressNext(true);
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Services services = Services();

    Timer? timeoutTimer;
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
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      final DateFormat date = DateFormat('yyyy-MM-dd HH:mm:ss');
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 10);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      String urlAudio = '';
      if (response.statusCode == 200) {
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putFile(File(file!), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
        timeoutTimer = Timer(const Duration(seconds: 10), () {
          uploadTask!.cancel();
        });
        urlAudio = await (await uploadTask).ref.getDownloadURL();
      }
      Formulario formulario = Formulario(
        createAt: date.format(DateTime.now()).toString(), 
        latitud: locationData!.latitude!, 
        longitud: locationData.longitude!,
        a: form.a, 
        b: form.b, 
        c: form.c, 
        d: form.d, 
        e: form.e, 
        f: form.f,
        g: form.g,
        h: form.h,
        i: form.i,
        j: form.j,
        k: form.k,
        nombre: encuestadoBloc.nameValue!, 
        apellidoPaterno: encuestadoBloc.apellidoPaternoValue!,
        apellidoMaterno: encuestadoBloc.apellidoMaternoValue!,
        telefono: encuestadoBloc.phoneValue!, 
        versionapp: version,
        uidUser: userModel.id.toString(),
        email: userModel.correo,
        urlAudio: urlAudio,
        colonia: form.colonia!,
        calle: form.calle!,
        numero: form.numero,
        seccion: form.seccion,
        zona: form.zona,
        duracion: duracion
      );
      await services.addEncuesta(formulario: formulario).then((http.Response response) {
        if(response.statusCode != 200) {
          if(response.statusCode == 408) {
            respuestaUtilityModel.timeout = true;
          }
          throw response.body;
        }
      }).catchError((error) {
        if(error == 'La ubicacion no esta activa') {
          respuestaUtilityModel.mensaje = error;
        } else {
          respuestaUtilityModel.mensaje = 'Error, la encuesta no se guardo';
        }
        throw error;
      });
    
    } catch (e) {
      if(e is firebase_storage.FirebaseException) {
        timeoutTimer?.cancel();
        respuestaUtilityModel.timeout = true;
      } else if(e is SocketException){
        respuestaUtilityModel.timeout = true;
        respuestaUtilityModel.mensaje = 'Error al enviar encuesta';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = e.toString();
      }
      respuestaUtilityModel.error = true;
    }
    encuestadoBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  } 

  Future<RespuestaUtilityModel> sincronizar({
    required Formulario form,
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Services services = Services();

    try{
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 10);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      String urlAudio = '';
      if (response.statusCode == 200) {
        UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
        final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://data-analitica2.firebasestorage.app');
        firebase_storage.UploadTask? uploadTask;
        firebase_storage.Reference reference = storage.ref().child('${userModel.nombre}-${DateTime.now()}');
        uploadTask = reference.putFile(File(form.urlAudio!), firebase_storage.SettableMetadata(contentType: 'audio/mpeg'));
        urlAudio = await (await uploadTask).ref.getDownloadURL();
      }
      form.urlAudio = urlAudio;
      await services.addEncuesta(formulario: form).then((http.Response response) async {
        if(response.statusCode != 200) {
          throw response.body;
        }
        await GPSServices.instance.addLogs(accion: 'Sincronizar', apartado: "Inicio", descripcion: response.body);
        await DatabaseProvider.db.deleteEnc(int.parse(form.id!));
      }).catchError((error) {
        if(error == 'La ubicacion no esta activa') {
          respuestaUtilityModel.mensaje = error;
        } else {
          respuestaUtilityModel.mensaje = 'Error, la encuesta no se guardo';
        }
        throw error;
      });
    
    } catch (e) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = respuestaUtilityModel.mensaje;
    }
    return respuestaUtilityModel;
  } 


  
  Future<RespuestaUtilityModel> getColonias({
    required String seccion,
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      await Services().getColonias(
        seccion: seccion,
      ).then((http.Response response) async {
        if (response.statusCode != 200) {
          throw 'A ocurrido un error';
        }

        prefs.remove('calleSel');
        prefs.remove('coloniaSel');
        Map<String, dynamic> data = jsonDecode(response.body);
        List<String> colonias = [];
        List<String> calles = [];
        for (var json in data['Resultado']) {
          colonias.add(json['colonia']);
          calles.add(json['calle']);
        }
        
        colonias.add('Agregar colonia');
        colonias.add('Agregar ejido');
        calles.add('Otro');

        await prefs.setStringList('colonias', colonias);
        await prefs.setStringList('calles', calles);


      }).catchError((error) {
        throw error;
      });
    
    } catch (e) {
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'Inicio de sesion fallido';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = e.toString();
      }
      respuestaUtilityModel.error = true;
    }
    return respuestaUtilityModel;
  } 

  Future<RespuestaUtilityModel> getCercaSeccionalActiva({
    required String seccion,
  }) async {
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      DateTime actual = DateTime.now();
      await Services().getCercaSeccionalActiva(
        seccion: seccion,
        zona: userModel.zona,
        fecha: DateFormat('yyyy-MM-dd HH:mm:ss').format(actual).toString()
      ).then((http.Response response) async {
        if (response.statusCode != 200) {
          throw 'A ocurrido un error';
        }
        Map<String, dynamic> data = jsonDecode(response.body);
          SeccionModel seccionModel =
            SeccionModel.fromJson(data['resultado'][0]);
          await prefs.setString('sesion', jsonEncode(seccionModel.toJson()));
        
        if(data['resultado'].length > 1) {
          List<SeccionModel> secciones = [];
          for (var i = 0; i < data['resultado'].length; i++) {
            secciones.add(SeccionModel.fromJson(data['resultado'][i]));
          }

          final jsonList = secciones.map((s) => s.toJson()).toList();
          final jsonString = jsonEncode(jsonList);

          await prefs.setString('seccionesActivas', jsonString);
        }
      }).catchError((error) {
        throw error;
      });
    
    } catch (e) {
      prefs.remove('seccionesActivas');
      prefs.remove('colonias');
      prefs.remove('calles');
      prefs.remove('calleSel');
      prefs.remove('coloniaSel');
      prefs.remove('sesion');
      if(e is SocketException){
        respuestaUtilityModel.mensaje = 'Inicio de sesion fallido';
      } else if(e is TimeoutException){
        respuestaUtilityModel.mensaje = 'No hay conexion a internet';
      } else {
        respuestaUtilityModel.mensaje = e.toString();
      }
      respuestaUtilityModel.error = true;
    }
    return respuestaUtilityModel;
  } 
}