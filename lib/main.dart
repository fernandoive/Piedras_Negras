import 'dart:async';
import 'dart:convert';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/home/home_screen.dart';
import 'package:data_analitica_2/screens/login/login_screen.dart';
import 'package:data_analitica_2/services/back_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = false;
  UserModel? userModel;
  try{
    userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
  } catch (e) {}
  if(userModel != null) {
    isLogged = true;
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) { 
    runApp(MyApp(isLogged: isLogged));
  });
}


class MyApp extends StatefulWidget {
  final bool isLogged;
  const MyApp({
    required this.isLogged,
    super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Timer? _inactivityTimer;
  static const int timeoutSeconds = 5;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initializeService();
    // _resetTimer();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(minutes: timeoutSeconds), () {
      navigatorKey.currentState?.push(CupertinoPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piedras Negras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget.isLogged ? HomeScreen() :  LoginScreen(),
    );
  }
}
