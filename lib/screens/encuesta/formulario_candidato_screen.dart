import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/encuesta/bloc/encuesta_bloc.dart';
import 'package:data_analitica_2/screens/encuesta/formulario_encuestado_screen.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/widgets/boton_widget.dart';
import 'package:data_analitica_2/widgets/drop_widget.dart';
import 'package:data_analitica_2/widgets/encabezado_widget.dart';
import 'package:data_analitica_2/widgets/input_widget.dart';
import 'package:data_analitica_2/widgets/loader_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';

class FormularioCandidato extends StatefulWidget {
  final String seccion;
  final String zona;
  final String calle;
  final String colonia;
  final UserModel userModel;
  final String numero;
  const FormularioCandidato({
    super.key, 
    required this.seccion, 
    required this.zona, 
    required this.calle, 
    required this.colonia, 
    required this.userModel, 
    required this.numero});

  @override
  State<FormularioCandidato> createState() => _FormularioCandidatoState();
}

class _FormularioCandidatoState extends State<FormularioCandidato> {

  late EncuestaBloc encuestaBloc;

  RecorderController recorderController = RecorderController()
                                          ..androidEncoder = AndroidEncoder.aac
                                          ..androidOutputFormat = AndroidOutputFormat.mpeg4
                                          ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
                                          ..sampleRate = 44100;
  late Directory appDirectory;
  String path = '';

  @override
  void initState() {
    encuestaBloc = EncuestaBloc();
    checkPermission();
    addlog(accion: 'Navegacion', apartado: 'Encuesta ciudadana', descripcion: 'Inicio una nueva encuesta');
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
    encuestaBloc.dispose();
    recorderController.dispose();
    super.dispose();
  }

  Future<void> checkPermission() async {
    bool permission = await recorderController.checkPermission();
    if(permission) {
      await recorderController.record();  
    }
  }

  void getDirectorio() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/${DateTime.now()}audio.m4a";
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWidget(
      streamMostrarCircularProgress: encuestaBloc.mostrarCircularProgress,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Encuesta Ciudadana'),
          elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
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
          EncabezadoWidget(encabezdo: 'APERTURA OBLIGATORIA (el COT lo dice tal cual)'),
          EncabezadoWidget(encabezdo: 'Buenas tardes, mi nombre es ${widget.userModel.nombre} ${widget.userModel.apellidoP}, soy vecino(a) de aquí y formo parte de un equipo que está recorriendo todas las colonias de Piedras Negras para escuchar a la gente. ¿Me puede regalar unos minutos?'),
          EncabezadoWidget(encabezdo: '(Si la respuesta es sí, continúa. No mencionar a Mayra todavía.)'),
          EncabezadoWidget(encabezdo: '1. Conocimiento previo'.toUpperCase()),
          EncabezadoWidget(encabezdo: '1. Antes de esta visita, ¿había escuchado hablar de Mayra Rubí Rangel?'),
          DropWidget(next: encuestaBloc.pregunta1Next, value: encuestaBloc.pregunta1Value, stream: encuestaBloc.pregunta1, listItems: p1),
          EncabezadoWidget(encabezdo: '2. ¿Dónde o por qué la ubica principalmente?'),
          DropWidget(next: encuestaBloc.pregunta2Next, value: encuestaBloc.pregunta2Value, stream: encuestaBloc.pregunta2, listItems: p2),
          StreamBuilder(
            stream: encuestaBloc.pregunta2,
            builder: (context, snapshot) {
              String value = '';
              if(snapshot.hasData) {
                value = snapshot.data!;
              }
              return value == 'Otro' ? Column(
                children: [
                  EncabezadoWidget(encabezdo: 'Otro*'),
                  InputWidget(
                    textCapitalization: true,
                    textEditingController: encuestaBloc.p2otroControllerValue, 
                    value: encuestaBloc.p2otroValue, 
                    stream: encuestaBloc.p2otro, 
                    next: encuestaBloc.p2otroNext
                  ),
                ],
              ) : SizedBox();
            }
          ),
          
          EncabezadoWidget(encabezdo: '3. En general, ¿qué opinión tiene de Mayra Rubí?'),
          DropWidget(next: encuestaBloc.pregunta3Next, value: encuestaBloc.pregunta3Value, stream: encuestaBloc.pregunta3, listItems: p3),
          EncabezadoWidget(encabezdo: '3. Prioridades reales del hogar'.toUpperCase()),
          EncabezadoWidget(encabezdo: '4. Pensando en su colonia, ¿cuál considera que es el principal problema hoy?'),
          DropWidget(next: encuestaBloc.pregunta4Next, value: encuestaBloc.pregunta4Value, stream: encuestaBloc.pregunta4, listItems: p4),
          StreamBuilder(
            stream: encuestaBloc.pregunta4,
            builder: (context, snapshot) {
              String value = '';
              if(snapshot.hasData) {
                value = snapshot.data!;
              }
              return value == 'Otro' ? Column(
                children: [
                  EncabezadoWidget(encabezdo: 'Otro*'),
                  InputWidget(
                    textCapitalization: true,
                    textEditingController: encuestaBloc.p4otroControllerValue, 
                    value: encuestaBloc.p4otroValue, 
                    stream: encuestaBloc.p4otro, 
                    next: encuestaBloc.p4otroNext
                  ),
                ],
              ) : SizedBox();
            }
          ),
          
          EncabezadoWidget(encabezdo: '5. En una escala del 0 al 10, ¿qué tan urgente es atender ese problema?'),
          DropWidget(next: encuestaBloc.pregunta5Next, value: encuestaBloc.pregunta5Value, stream: encuestaBloc.pregunta5, listItems: p5),
          EncabezadoWidget(encabezdo: '6. ¿Ha solicitado apoyo o gestión antes a alguna autoridad?'),
          DropWidget(next: encuestaBloc.pregunta6Next, value: encuestaBloc.pregunta6Value, stream: encuestaBloc.pregunta6, listItems: p6),
          EncabezadoWidget(encabezdo: '(se aplica a quien NO la conoce o la conoce poco; refuerza a quien sí la conoce)'),
          EncabezadoWidget(encabezdo: 'Le platico brevemente quién es Mayra Rubí Rangel. Mayra Rubí es de aquí, de Piedras Negras. Es licenciada en Psicología, fue maestra, ha sido regidora y actualmente trabaja directamente en programas de Bienestar, apoyando a familias en temas de salud, educación y gestiones sociales.'),
          EncabezadoWidget(encabezdo: 'La forma de hacer política de Mayra Rubí es en territorio, recorriendo colonias, escuchando a la gente y resolviendo, no desde la oficina. Hoy estamos recorriendo todas las secciones de Piedras Negras, casa por casa, para que la gente conozca quién es Mayra Rubí y para escuchar lo que vive cada colonia.'),
          EncabezadoWidget(encabezdo: '7. Con lo que acaba de escuchar, ¿cómo describiría a Mayra Rubí?'),
          DropWidget(next: encuestaBloc.pregunta7Next, value: encuestaBloc.pregunta7Value, stream: encuestaBloc.pregunta7, listItems: p7),
          StreamBuilder(
            stream: encuestaBloc.pregunta7,
            builder: (context, snapshot) {
              String value = '';
              if(snapshot.hasData) {
                value = snapshot.data!;
              }
              return value == 'Otro' ? Column(
                children: [
                  EncabezadoWidget(encabezdo: 'Otro*'),
                  InputWidget(
                    textCapitalization: true,
                    textEditingController: encuestaBloc.p7otroControllerValue, 
                    value: encuestaBloc.p7otroValue, 
                    stream: encuestaBloc.p7otro, 
                    next: encuestaBloc.p7otroNext
                  ),
                ],
              ) : SizedBox();
            }
          ),
          
          EncabezadoWidget(encabezdo: '8. De lo que le comenté, ¿qué le parece más importante del perfil de Mayra Rubí?'),
          DropWidget(next: encuestaBloc.pregunta8Next, value: encuestaBloc.pregunta8Value, stream: encuestaBloc.pregunta8, listItems: p8),
          EncabezadoWidget(encabezdo: '9. Hoy en día, ¿usted cree que hacen falta representantes que'),
          DropWidget(next: encuestaBloc.pregunta9Next, value: encuestaBloc.pregunta9Value, stream: encuestaBloc.pregunta9, listItems: p9),
          EncabezadoWidget(encabezdo: '10. Pensando en perfiles como el de Mayra Rubí, ¿usted diría que?'),
          DropWidget(next: encuestaBloc.pregunta10Next, value: encuestaBloc.pregunta10Value, stream: encuestaBloc.pregunta10, listItems: p10),
          EncabezadoWidget(encabezdo: '11. Si Mayra Rubí Rangel fuera candidata a diputada local, hoy usted se sentiría'),
          DropWidget(next: encuestaBloc.pregunta11Next, value: encuestaBloc.pregunta11Value, stream: encuestaBloc.pregunta11, listItems: p11,),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 80),
            child: BotonWidget(
              onPressed: () {
                Formulario formulario = Formulario(
                  a: encuestaBloc.pregunta1Value,
                  b: encuestaBloc.pregunta2Value == 'Otro' ? encuestaBloc.p2otroValue : encuestaBloc.pregunta2Value,
                  c: encuestaBloc.pregunta3Value,
                  d: encuestaBloc.pregunta4Value == 'Otro' ? encuestaBloc.p4otroValue : encuestaBloc.pregunta4Value,
                  e: encuestaBloc.pregunta5Value,
                  f: encuestaBloc.pregunta6Value,
                  g: encuestaBloc.pregunta7Value == 'Otro' ? encuestaBloc.p7otroValue : encuestaBloc.pregunta7Value,
                  h: encuestaBloc.pregunta8Value,
                  i: encuestaBloc.pregunta9Value,
                  j: encuestaBloc.pregunta10Value,
                  k: encuestaBloc.pregunta11Value,
                  zona: widget.zona,
                  seccion: widget.seccion,
                  calle: widget.calle,
                  colonia: widget.colonia,
                  numero: widget.numero
                );
                Navigator.push(context, CupertinoPageRoute(builder: (context) => FormularioEncuestado(formulario: formulario, recorderController: recorderController, path: path,)));
              }, 
              label: 'Continuar', 
              stream: encuestaBloc.formularioCandidatoStream
            ),
          )
        ],
    );
  }

  Widget image(asset, tag, Color back, Color close) {
    return GestureDetector(
      onTap: () {
        showImageViewer(
          context,
          Image.asset(asset).image,
          swipeDismissible: true,
          doubleTapZoomable: true,
          backgroundColor: back,
          closeButtonColor: close
        );
      },
      child: Container(
        height: 250,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: ClipRRect(
            child: Image.asset(
              asset,
              fit: BoxFit.cover       
            ),
          ),
        ),
      ),
    );
  }
}