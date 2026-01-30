import 'dart:convert';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/home/home_screen.dart';
import 'package:data_analitica_2/screens/login/bloc/login_bloc.dart';
import 'package:data_analitica_2/services/auth/auth_services.dart';
import 'package:data_analitica_2/widgets/boton_widget.dart';
import 'package:data_analitica_2/widgets/input_widget.dart';
import 'package:data_analitica_2/widgets/loader_widget.dart';
import 'package:data_analitica_2/widgets/snackbar_widget.dart';
import 'package:data_analitica_2/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late LoginBloc loginBloc;
  bool obscureText = true;
  UserModel? userModel;
  bool biometric = false;
  bool pin = false;
  bool pass = false;
  bool face = false;

  @override
  void initState() {
    loginBloc = LoginBloc();
    // getUser();
    super.initState();
  }

  void getUser() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      setState(() {});
      if(userModel != null) {
        checkBiometrics();
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    loginBloc.dispose();
    super.dispose();
  }

  void checkBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        authMessages: [
          AndroidAuthMessages(
            biometricHint: 'Verificar identidad',
            signInTitle: 'Por favor identificate',
            cancelButton: 'No gracias',
          ),
        ],
        options: const AuthenticationOptions(useErrorDialogs: true),
        localizedReason: 'Autenticate para entrar');
      if(didAuthenticate) {
        await loginBiometric();
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.lockedOut) {
        toast('Bloqueado temporalmente, debido a muchos intentos');
      } else if (e.code == auth_error.notAvailable) {
        toast('Biometrico no soportado');
      } else if (e.code == auth_error.passcodeNotSet) {
        toast('El usuario aún no ha configurado un código de acceso');
      } else { 
        toast('Error $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWidget(
      streamMostrarCircularProgress: loginBloc.mostrarCircularProgress,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: boton(),
          ),
          body: body(),
        ),
      ),
      
    );

  }

  Widget body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            title(),
            email(),
            password(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.only(bottom: 20, left: 20, top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),  
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, ingresa tu correo y contraseña',
                style: TextStyle(
                  fontSize: 14,
                ),  
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget email() {
    return InputWidget(
      label: 'Correo electronico',
      textEditingController: loginBloc.correoControllerValue,
      value: loginBloc.correoValue,
      next: loginBloc.correoNext,
      stream: loginBloc.correo,
    );
  }

  Widget password() {
    return InputWidget(
      label: 'Contraseña',
      textEditingController: loginBloc.passwordControllerValue,
      value: loginBloc.passwordValue,
      next: loginBloc.passwordNext,
      stream: loginBloc.password,
      password: true,
      obscureText: obscureText,
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
    );
  }

  Widget boton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: BotonWidget(
        onPressed: () async {
          await loginEmailPassword();
        }, 
        label: 'Iniciar sesión',
        stream: loginBloc.formularioStream,
      ),
    );
  }

  Future<void> loginBiometric() async {
    RespuestaUtilityModel respuestaUtilityModel =
        await AuthServices.instance.loginBiometric(loginBloc: loginBloc, user: userModel);
    if(respuestaUtilityModel.error) {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarError(message:respuestaUtilityModel.mensaje));
    } else {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    }
  }

    Future<void> loginEmailPassword() async {
    RespuestaUtilityModel respuestaUtilityModel =
        await AuthServices.instance.loginEmailPassword(loginBloc: loginBloc);
    if(respuestaUtilityModel.error) {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarError(message:respuestaUtilityModel.mensaje));
    } else {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    }
  }
}