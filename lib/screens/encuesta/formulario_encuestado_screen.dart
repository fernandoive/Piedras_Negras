import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:data_analitica_2/models/respuesta_utility_model.dart';
import 'package:data_analitica_2/screens/encuesta/bloc/encuestado_bloc.dart';
import 'package:data_analitica_2/screens/home/home_screen.dart';
import 'package:data_analitica_2/services/encuesta/encuesta_service.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/widgets/boton_widget.dart';
import 'package:data_analitica_2/widgets/drop_widget.dart';
import 'package:data_analitica_2/widgets/encabezado_widget.dart';
import 'package:data_analitica_2/widgets/input_widget.dart';
import 'package:data_analitica_2/widgets/snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/loader_widget.dart';

class FormularioEncuestado extends StatefulWidget {
  final Formulario formulario;
  final RecorderController recorderController;
  final String path;
  const FormularioEncuestado({
    super.key,
    required this.formulario,
    required this.recorderController, required this.path
  });

  @override
  State<FormularioEncuestado> createState() => _FormularioEncuestadoState();
}

class _FormularioEncuestadoState extends State<FormularioEncuestado> {
  
  late EncuestadoBloc encuestadoBloc;
  var file = '';
  String duracion = '';
  List<String> colonias = [];

  @override
  void initState() {
    encuestadoBloc = EncuestadoBloc();
    addlog(accion: 'Navegacion', apartado: 'Encuestado', descripcion: 'Continua la identificacion humana');

    super.initState();
  }

  Future<void> addlog({
    required String accion,
    required String apartado,
    required String descripcion
  }) async {
    bool result = await InternetConnection().hasInternetAccess;
    if(result) {
      await GPSServices.instance.addLogs(accion: accion, apartado: apartado, descripcion: descripcion);
    }
  }

  @override
  void dispose() {
    encuestadoBloc.dispose();
    super.dispose();
  }

  void getColonias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    colonias = prefs.getStringList('colonias') ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWidget(
      streamMostrarCircularProgress: encuestadoBloc.mostrarCircularProgress,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Encuestado'),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
        ),
        body: body(),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Versión: $version',
                  style: TextStyle(
                    fontSize: 15,
                    color: primaryColor
                  ),
                )
              ],
            ),
          ),
          EncabezadoWidget(encabezdo: 'Nombre(s)*'),
          InputWidget(
            textCapitalization: true,
            textEditingController: encuestadoBloc.nameControllerValue, 
            value: encuestadoBloc.nameValue, 
            stream: encuestadoBloc.name, 
            next: encuestadoBloc.nameNext
          ),
          EncabezadoWidget(encabezdo: 'Apellido paterno*'),
          InputWidget(
            textCapitalization: true,
            textEditingController: encuestadoBloc.apellidoPaternoControllerValue, 
            value: encuestadoBloc.apellidoPaternoValue, 
            stream: encuestadoBloc.apellidoPaterno, 
            next: encuestadoBloc.apellidoPaternoNext
          ),
          EncabezadoWidget(encabezdo: 'Apellido materno*'),  
          InputWidget(
            textCapitalization: true,
            textEditingController: encuestadoBloc.apellidoMaternoControllerValue, 
            value: encuestadoBloc.apellidoMaternoValue, 
            stream: encuestadoBloc.apellidoMaterno, 
            next: encuestadoBloc.apellidoMaternoNext
          ),
          EncabezadoWidget(encabezdo: 'Telefono*'),
          InputWidget(
            textCapitalization: true,
            textEditingController: encuestadoBloc.phoneControllerValue, 
            value: encuestadoBloc.phoneValue, 
            stream: encuestadoBloc.phone, 
            next: encuestadoBloc.phoneNext,
            textInputType: TextInputType.phone,
            maxLength: 10,
          ),
          EncabezadoWidget(encabezdo: 'Colonia seleccionada:'),
          EncabezadoWidget(encabezdo: widget.formulario.colonia!),
          EncabezadoWidget(encabezdo: 'Calle seleccionada:'),
          EncabezadoWidget(encabezdo: widget.formulario.calle!),
          EncabezadoWidget(encabezdo: 'Número de casa seleccionada:'),
          EncabezadoWidget(encabezdo: widget.formulario.numero!),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: BotonWidget(
              onPressed: () async {
                bool result = await InternetConnection().hasInternetAccess;
                if(result == true) {
                  dialog('¿Estas seguro de enviar la encuesta?', true);
                } else {
                  dialog('No cuentas con internet, ¿Estas seguro de guardar la encuesta localmente?', false);
                }
              }, 
              label: 'Enviar', 
              stream: encuestadoBloc.formularioStream
            ),
          )
        ],
      ),
    );
  }

  Future<void> dialog(text, connection) async {
    await Dialogs.materialDialog(
      msg: text,
      title: "Aviso",
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'Cancelar',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () { 
            Navigator.pop(context);
            if(connection) {
              encuestaFirebase();
            } else {
              local();
            }
          },
          text: "Enviar",
          iconData: Icons.send_outlined,
          color: primaryColor,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
  }

  Future<void> local() async {
    if(file == '') {
      String? path2 = widget.path; 
      path2 = await widget.recorderController.stop(false);
      duracion = widget.recorderController.recordedDuration.toHHMMSS();
      file = File(path2!).path;
    }
    RespuestaUtilityModel respuestaUtilityModel = await EncuestaServices.instance.encuestaLocal(encuestadoBloc: encuestadoBloc, form: widget.formulario, file: file, duracion: duracion);
    if(respuestaUtilityModel.error) {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarError(message:respuestaUtilityModel.mensaje));
    } else {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarSuccess(message: 'Encuesta guardada correctamente'));
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    }
  }

  Future<void> encuestaFirebase() async {
    if(file == '') {
      String? path2 = widget.path; 
      path2 = await widget.recorderController.stop(false);
      duracion = widget.recorderController.recordedDuration.toHHMMSS();
      file = File(path2!).path;
    }
    RespuestaUtilityModel respuestaUtilityModel = await EncuestaServices.instance.encuestaFirebase(encuestadoBloc: encuestadoBloc, form: widget.formulario, file: file, duracion: duracion);
    if(respuestaUtilityModel.timeout) {
      await local();
    } else if(respuestaUtilityModel.error) {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarError(message:respuestaUtilityModel.mensaje));
    } else {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarSuccess(message: 'Encuesta guardada correctamente'));
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
    }
  }
}