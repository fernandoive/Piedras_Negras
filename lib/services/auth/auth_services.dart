import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/login/bloc/login_bloc.dart';
import 'package:data_analitica_2/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthServices {

  AuthServices._();
  static final AuthServices instance = AuthServices._();

  Future<RespuestaUtilityModel> loginBiometric({
    required LoginBloc loginBloc,
    UserModel? user
  }) async {
    loginBloc.mostrarCircularProgressNext(true);
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      await Services().login(
        email: user != null ? user.correo : loginBloc.correoValue!, 
        password: user != null ? user.password : loginBloc.passwordValue!
      ).then((http.Response response) async {
        if (response.statusCode != 200) {
          Map<String, dynamic> body = jsonDecode(response.body);
          throw body['msg'];
        }
        Map<String, dynamic> userMap = jsonDecode(response.body);
        UserModel userModel =
          UserModel.fromJson(userMap['usuario'], user != null ? user.password : loginBloc.passwordValue!);
        await prefs.setString('user', jsonEncode(userModel.toJson()));
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
    loginBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  } 

  Future<RespuestaUtilityModel> loginEmailPassword({
    required LoginBloc loginBloc,
  }) async {
    loginBloc.mostrarCircularProgressNext(true);
    final RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      await Services().login(
        email: loginBloc.correoValue!, 
        password: loginBloc.passwordValue!
      ).then((http.Response response) async {
        if (response.statusCode != 200) {
          Map<String, dynamic> body = jsonDecode(response.body);
          throw body['msg'];
        }
        Map<String, dynamic> userMap = jsonDecode(response.body);
        UserModel userModel =
          UserModel.fromJson(userMap['usuario'], loginBloc.passwordValue!);
        await prefs.setString('user', jsonEncode(userModel.toJson()));
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
    loginBloc.mostrarCircularProgressNext(false);
    return respuestaUtilityModel;
  } 
}