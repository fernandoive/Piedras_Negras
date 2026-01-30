import 'dart:io';

import 'package:camera/camera.dart';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/home/bloc/check_bloc.dart';
import 'package:data_analitica_2/screens/home/home_screen.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/widgets/boton_widget_normal.dart';
import 'package:data_analitica_2/widgets/encabezado_widget.dart';
import 'package:data_analitica_2/widgets/loader_widget.dart';
import 'package:data_analitica_2/widgets/snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool photo = false;
  File? url;
  UserModel userModel = UserModel();
  final pickerFoto = ImagePicker();
  LocationData? locationData;
  final DateFormat date = DateFormat('yyyy-MM-dd HH:mm');
  Uint8List? imageBytes;
  GlobalKey globalKey = GlobalKey();
  String direccion = '';
  String estado = '';
  late CheckBloc checkBloc;

    late CameraController _controller;
  bool cameraReady = false;

  @override
  void initState() {
    checkBloc = CheckBloc();
    getLocation();
    addlog();
    getUser();
    initCamera();
    super.initState();
  }

  Future<void> addlog() async {
    bool result = await InternetConnection().hasInternetAccess;
    if(result) {
      await GPSServices.instance.addLogs(accion: 'Navegacion', apartado: 'CheckIn', descripcion: 'Entro a la pantalla de CheckIn');
    }
  }

    Future<void> initCamera() async {
  final cameras = await availableCameras();

  final frontCamera = cameras.firstWhere(
    (c) => c.lensDirection == CameraLensDirection.front,
  );

  _controller = CameraController(
    frontCamera,
    ResolutionPreset.high,
    enableAudio: false,
  );

  await _controller.initialize();
  cameraReady = true;
}

  void getLocation() async {
    checkBloc.mostrarCircularProgressNext(true);
    Location location = Location();
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
    if(locationData != null) {
      await obtenerDireccion(locationData!.latitude!, locationData!.longitude!);
    }
    checkBloc.mostrarCircularProgressNext(false);
    setState(() {});
  }

  Future<void> obtenerDireccion(double latitud, double longitud) async {
    try {
      var client = HttpClient();
      client.connectionTimeout = Duration(seconds: 5);
      var request = await client.getUrl(Uri.parse('https://api.pn2026.dataanalitica.net/'));
      var response = await request.close();
      if (response.statusCode == 200) {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(latitud, longitud);

      if (placemarks.isNotEmpty) {
        final geo.Placemark lugar = placemarks.first;
        estado = '${lugar.locality}, ${lugar.administrativeArea},  ${lugar.country}';
        direccion = '${lugar.street}';
      }
      } else {
        throw response;
      }
    } catch (e) {
      if(e is SocketException) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBarWidget.instance.snackBarError(message: 'No hay conexion a internet'));
      }
    checkBloc.mostrarCircularProgressNext(false);
    }
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
    setState(() {});
  }

  void tomarFoto() async {
    if (!cameraReady || !_controller.value.isInitialized) return;

    final XFile image = await _controller.takePicture();

    setState(() {
      url = File(image.path);
      photo = true;
    });
  }

  crearImagen() async {
    ui.Image data = await _signaturePadKey.currentState!.toImage(pixelRatio: 2.0);
    final byteData = await data.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      imageBytes = byteData!.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    });
  }

  Future<void> capturarYGuardar() async {
    try {
      checkBloc.mostrarCircularProgressNext(true);
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      imageBytes = byteData!.buffer.asUint8List();
      setState(() {});
      RespuestaUtilityModel respuestaUtilityModel =
          await GPSServices.instance.addCheck(
            image: imageBytes!,
            type: 'IN',
            latitud: locationData!.latitude!.toString(),
            longitud: locationData!.longitude.toString()
          );
      if(respuestaUtilityModel.error) {
        ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBarWidget.instance.snackBarError(message:respuestaUtilityModel.mensaje));
      } else {
        checkBloc.mostrarCircularProgressNext(false);
        ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBarWidget.instance.snackBarSuccess(message: 'Guardado'));
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      checkBloc.mostrarCircularProgressNext(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWidget(
      streamMostrarCircularProgress: checkBloc.mostrarCircularProgress,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          title: Text('Check-in'),
          centerTitle: true,
          elevation: 0,
          actions: [
            if(photo) ...[
              IconButton(onPressed: () {
                capturarYGuardar();
              }, icon: Icon(Icons.send))
            ]
          ],
          backgroundColor: primaryColor,
        ),
        body: !photo ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Mira directamente a la camara',
                style: TextStyle(                
                  fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 18.0),
                ),
              ),
              BotonWidgetNormal(
                label: 'Tomar foto',
                onPressed: () => tomarFoto(),
                enable: true,
                color: primaryColor,
              ),
            ],
          ),
        ) : RepaintBoundary(
          key: globalKey,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      url!
                    )
                  ),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1,
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    onDrawStart: () {
                      return true;
                    },
                    strokeColor: Colors.black54,
                    minimumStrokeWidth: 2.0,
                    maximumStrokeWidth: 4.0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  margin: EdgeInsets.all(5),
                  color: Colors.black.withOpacity(0.3),
                  child: Row(
                    children: [
                      Image.asset('assets/map.PNG', width: 100,),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                  estado,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/casa.png', width: 13),
                                  SizedBox(width: 10),
                                  Text(
                                    direccion,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${userModel.nombre} ${userModel.apellidoP}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                              ),
                              if(locationData != null) ...[
                                Row(
                                  children: [
                                    Image.asset('assets/coordenadas.png', width: 13),
                                    SizedBox(width: 10),
                                    Text(
                                      '${locationData!.latitude}, ${locationData!.longitude}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              Row(
                                children: [
                                  Image.asset('assets/calendario.png', width: 13),
                                  SizedBox(width: 10),
                                  Text(
                                    date.format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                                
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}