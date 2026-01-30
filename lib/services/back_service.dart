import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:data_analitica_2/models/gps_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/services/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Timer.periodic(const Duration(minutes: 3), (timer) async {
    try{
      UserModel? userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
      if (!isWithinWorkingHours() && userModel == null) return;

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
            }
          } else {
            locationData = await location.getLocation();
          }
        }
      final Services services = Services();

      GPSModel model = GPSModel(
        latitud: locationData!.latitude,
        longitud: locationData.longitude,
        unameUser: userModel.nombre,
        utypeUser: userModel.correo
      ); 

      await services.addCoordenada(gpsModel: model);
    } catch (e) {}
  });
}

bool isWithinWorkingHours() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day, 8, 0);
  final end = DateTime(now.year, now.month, now.day, 18, 0);
  return now.isAfter(start) && now.isBefore(end);
}
