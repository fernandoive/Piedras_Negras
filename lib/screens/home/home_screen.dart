import 'dart:convert';

import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:data_analitica_2/models/seccion_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:data_analitica_2/screens/encuesta/formulario_candidato_screen.dart';
import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:data_analitica_2/screens/home/checkin_screen.dart';
import 'package:data_analitica_2/screens/home/checkout_screen.dart';
import 'package:data_analitica_2/screens/home/widgets/drawer_widget.dart';
import 'package:data_analitica_2/services/database/database.dart';
import 'package:data_analitica_2/services/encuesta/encuesta_service.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/services/services.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/util/utils.dart';
import 'package:data_analitica_2/widgets/boton_widget.dart';
import 'package:data_analitica_2/widgets/chips_widget.dart';
import 'package:data_analitica_2/widgets/dropdown_colonia_calle.dart';
import 'package:data_analitica_2/widgets/dropdown_widget.dart';
import 'package:data_analitica_2/widgets/encabezado_widget.dart';
import 'package:data_analitica_2/widgets/input_widget.dart';
import 'package:data_analitica_2/widgets/loader_widget.dart';
import 'package:data_analitica_2/widgets/snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final String _tituloAppBar = 'Inicio';
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  String diario = '0';
  String mensual = '0';
  SeccionModel seccionModel = SeccionModel();

  late HomeBloc homeBloc;

  bool isJZ = false;
  List<String> activas = [];

  @override
  void initState() {
    homeBloc = HomeBloc();
    getUser();
    addlog(accion: 'Inicio de sesion', apartado: 'Inicio', descripcion: 'Entro al inicio de la aplicacion');
    getSesion();
    getCount();
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

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
    setState(() {
      isJZ = userModel.rol == 'JZ';  
    });
    homeBloc.userNext(userModel);
  }

  Future<void> getColonias() async {
    try{
      bool result = await InternetConnection().hasInternetAccess;
      if(result) {
        homeBloc.mostrarCircularProgressNext(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));

        await GPSServices.instance.addLogs(accion: 'Ejecucion de servicio', apartado: 'Inicio', descripcion: 'Obtiene datos de seccion activa, colonias y calles');

        await EncuestaServices.instance.getCercaSeccionalActiva(seccion: userModel.secciones);
        SeccionModel seccionModel = SeccionModel.fromData(jsonDecode(prefs.getString('sesion')!));

        if(seccionModel.fin.isNotEmpty) {
          homeBloc.sesionNext(seccionModel);
          homeBloc.seccionNext(seccionModel.seccion);
          homeBloc.activoNext(true);
          await EncuestaServices.instance.getColonias(seccion: seccionModel.seccion);

          if(isJZ) {

            final jsonString = prefs.getString('seccionesActivas');
            if (jsonString != null) {
              final List decoded = jsonDecode(jsonString);
              final res = decoded.map((e) => SeccionModel.fromData(e)).toList();
              homeBloc.seccionesActivasNext(res);
              for(int i = 0; i < res.length; i++) {
                activas.add(res[i].seccion);
              }
            }
          }

        } else {
          homeBloc.sesionNext(SeccionModel());
          homeBloc.seccionNext(seccionModel.seccion);
          homeBloc.activoNext(false);
          homeBloc.seccionesActivasNext([]);
        }

        var colonias = prefs.getStringList('colonias') ?? [];
        var calles = prefs.getStringList('calles') ?? [];

        homeBloc.coloniaSelectedNext('');
        homeBloc.calleSelectedNext('');
        homeBloc.coloniasNext(colonias.toSet().toList());
        homeBloc.callesNext(calles.toSet().toList());
        homeBloc.mostrarCircularProgressNext(false);
      }
    } catch (e) {
      homeBloc.mostrarCircularProgressNext(false);
      homeBloc.activoNext(false);
    }
      setState(() {});
  }

  void getSesion() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      seccionModel = SeccionModel.fromData(jsonDecode(prefs.getString('sesion')!));
      
        DateTime actual = DateTime.now();
        var fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(actual);
        if(DateTime.parse(fecha).isAfter(DateTime.parse(seccionModel.fin))) {
          prefs.remove('sesion');
          prefs.remove('colonias');
          prefs.remove('calles');
          prefs.remove('calleSel');
          prefs.remove('coloniaSel');
          homeBloc.activoNext(false);
          homeBloc.seccionSaveNext(false);
          homeBloc.sesionNext(SeccionModel());
          homeBloc.seccionNext('');
          await getColonias();

        } else {
          homeBloc.sesionNext(seccionModel);
          homeBloc.seccionNext(seccionModel.seccion);
          homeBloc.activoNext(true);
          homeBloc.seccionSaveNext(true);

          var colonias = prefs.getStringList('colonias') ?? [];
          var calles = prefs.getStringList('calles') ?? [];
          var coloniaSel = prefs.getString('coloniaSel');
          var callesSel = prefs.getString('calleSel');

          homeBloc.coloniasNext(colonias.toSet().toList());
          homeBloc.callesNext(calles.toSet().toList());
          if(coloniaSel != null) {
            homeBloc.coloniaSelectedNext(coloniaSel);
          }

          if(callesSel != null) {
            homeBloc.calleSelectedNext(callesSel);
          }

          if(isJZ) {
            final jsonString = prefs.getString('seccionesActivas');
            if (jsonString != null) {
              final List decoded = jsonDecode(jsonString);
              final res = decoded.map((e) => SeccionModel.fromData(e)).toList();
              homeBloc.seccionesActivasNext(res);
              for(int i = 0; i < res.length; i++) {
                activas.add(res[i].seccion);
              }
            }
          }

        }
      setState(() {});
    } catch (e) {
      homeBloc.coloniasNext([]);
      homeBloc.callesNext([]);
      homeBloc.coloniaSelectedNext('');
      homeBloc.calleSelectedNext('');
      homeBloc.seccionSaveNext(false);
      await getColonias();
    }
  }

  void getCount() async {
    try{
      bool result = await InternetConnection().hasInternetAccess;
      if(result) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel userModel = UserModel.fromData(jsonDecode(prefs.getString('user')!));
        homeBloc.userNext(userModel);
        var res = await Services().getEncuestaTotales(usuario: userModel.correo);
        var dec = jsonDecode(res.body);
        diario = dec['totalHoy'].toString();
        mensual = dec['totalMensual'].toString();
      }
      setState(() {});
    } catch (e) {}
  }

  
  @override
  Widget build(BuildContext context) {
    return LoaderWidget(
      streamMostrarCircularProgress: homeBloc.mostrarCircularProgress,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerWidget(controller: _controller, homeBloc: homeBloc,),
        appBar: AppBar(
          title: Text(_tituloAppBar),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.cloud_upload_outlined),
              onPressed: () async {
                bool result = await InternetConnection().hasInternetAccess;
                if(result) {
                  int count = await DatabaseProvider.db.obtenerEncuestasCount();
                  if(count > 0) {
                    dialog(count);
                  } else {
                    ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBarWidget.instance.snackBarWarning(message: 'No hay informacion para enviar'));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBarWidget.instance.snackBarError(message: 'No hay conexion a internet'));
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _button2('Total mensual: $mensual / 180', false),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _button2('Total hoy: $diario / 20', true),
              ),
              _container(),
              _container2(),
              SizedBox(
                height: 70,
                width: sizeTotalWidth(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor)
                    ),
                    onPressed: () {
                      if(homeBloc.activoValue! &&
                        homeBloc.calleSelectedValue!.isNotEmpty && homeBloc.calleSelectedValue != 'Otro' &&
                        homeBloc.coloniaSelectedValue!.isNotEmpty && homeBloc.coloniaSelectedValue != 'Agregar colonia' &&
                        homeBloc.coloniaSelectedValue != 'Agregar ejido'
                      ) {
                        Navigator.push(context, 
                        CupertinoPageRoute(builder: (context) => 
                        FormularioCandidato(
                          numero: homeBloc.numeroValue ?? 'N/A',
                          userModel: homeBloc.userValue,
                          seccion: homeBloc.sesionValue.seccion, 
                          zona: homeBloc.sesionValue.zona, 
                          calle: homeBloc.calleSelectedValue!, 
                          colonia: homeBloc.coloniaSelectedValue!)));
                      } else {
                        ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBarWidget.instance.snackBarError(message: 'No hay seccion, colonia o calle seleccionada'));
                      }
                    }, 
                    child: Text(
                      'Iniciar encuesta',
                      style: TextStyle(color: Colors.white, fontSize: 18)
                  )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _container() {
    return Column(
      children: [
        if(seccionModel.fin.isNotEmpty) ...{
          EncabezadoWidget(encabezdo: 'Bienvenido ${homeBloc.userValue.nombre}, hoy la sección en la que debes de trabajar será en ${homeBloc.seccionValue}'),
        },
        EncabezadoWidget(encabezdo: 'Seleccionar sección'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChipsWidget(
            isJZ: isJZ,
            secciones: homeBloc.userValue.secciones.split(',').map((e) => e.trim()).toList(), 
            next: homeBloc.seccionNext, 
            next2: homeBloc.sesionNext, 
            nextSave: homeBloc.seccionSaveNext, 
            activeSave: homeBloc.activoNext, 
            stream: homeBloc.seccion, 
            homeBloc: homeBloc,
            value: homeBloc.seccionValue,
            activas: activas
          ),
        )

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SizedBox(
        //     width: sizeTotalWidth(context),
        //     child: Card(
        //       color: Color(0xfb691c32),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: DropDownWidget(
        //         activeSave: homeBloc.activoNext,
        //         width: sizeWidthPerson(context, 0.8),
        //         label: "Seleccionar sección",
        //         next: homeBloc.seccionNext, 
        //         value: homeBloc.seccionValue, 
        //         stream: homeBloc.seccion, 
        //         listItems: homeBloc.userValue.secciones.split(',').map((e) => e.trim()).toList(),
        //         nextSave: homeBloc.seccionSaveNext,
        //         next2: homeBloc.sesionNext, homeBloc: homeBloc,
        //       ),
        //     ),
        //   ),
        // ),
      ]
    );
  }

  Widget _containerColonia(List<String> list) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: sizeTotalWidth(context),
            child: Card(
              color: Color(0xfb691c32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropDownColoniaWidget(
                label: "Seleccionar colonia",
                listItems: list,
                isCalle: false, 
                homeBloc: homeBloc,
              ),
            ),
          ),
        ),
      ]
    );
  }
  
  Widget _containerCalle(List<String> list) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: sizeTotalWidth(context),
            child: Card(
              color: Color(0xfb691c32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropDownColoniaWidget(
                label: "Seleccionar calle",
                listItems: list, 
                isCalle: true, 
                homeBloc: homeBloc,
              ),
            ),
          ),
        ),
      ]
    );
  }

  Widget _container2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: homeBloc.activo, 
        builder: (context, snap1) {
          bool activo = false;
          if(snap1.hasData) {
            activo = snap1.data!;
          }
          return activo ?
          SizedBox(
            width: sizeTotalWidth(context),
              child: Column(
                children: [
                  SizedBox(
                    width: sizeTotalWidth(context),
                    child: Card(
                      color: Color(0xfb691c32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    child: StreamBuilder(
                      stream: homeBloc.sesion, 
                        builder: (context, snap2) {
                          SeccionModel seccionModel = SeccionModel();
                          if(snap2.hasData) {
                            seccionModel = snap2.data!;
                          }
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Sección: ${seccionModel.seccion}',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  'Zona: ${seccionModel.zona}',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  'Municipio: ${seccionModel.municipio}',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  'Fecha inicio: ${seccionModel.inicio}',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  'Fecha fin: ${seccionModel.fin}',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                StreamBuilder(
                                  stream: homeBloc.coloniaSelected,
                                  builder: (context, snapshot) {
                                    String items = '';
                                    if(snapshot.hasData) {
                                      if(snapshot.data != 'Agregar colonia' && snapshot.data != 'Agregar ejido') {
                                        items = snapshot.data!;
                                      }
                                    }
                                    return Text(
                                      'Colonia seleccionada: $items',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    );
                                  }
                                ),
                                StreamBuilder(
                                  stream: homeBloc.calleSelected,
                                  builder: (context, snapshot) {
                                    String items = '';
                                    if(snapshot.hasData) {
                                      items = snapshot.data!;
                                    }
                                    return Text(
                                      'Calle seleccionada: $items',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    );
                                  }
                                ),
                            
                            ]),
                          );
                        }
                      )
                    ),
                  ),
                  StreamBuilder(
                    stream: homeBloc.colonias,
                    builder: (context, snapshot) {
                      List<String> items = [];
                      if(snapshot.hasData) {
                        items = snapshot.data!;
                      }
                      return items.isEmpty ? SizedBox() : StreamBuilder(
                        stream: homeBloc.coloniaSelected,
                        builder: (context, snapshot) {
                          String colonia = '';
                          if(snapshot.hasData) {
                            colonia = snapshot.data!;
                          }
                          return Column(
                            children: [
                              _containerColonia(items),
                              if(colonia == 'Agregar colonia') ...{
                                EncabezadoWidget(encabezdo: 'Agregar colonia*'),
                                InputWidget(
                                  textCapitalization: true,
                                  textEditingController: homeBloc.coloniaotroControllerValue, 
                                  value: homeBloc.coloniaotroValue, 
                                  stream: homeBloc.coloniaotro, 
                                  next: homeBloc.coloniaotroNext
                                ),
                                SizedBox(height: 20),
                                BotonWidget(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    addlog(accion: 'Agregar', apartado: 'Inicio', descripcion: 'Agrego una colonia manualmente');
                                    await prefs.setString('coloniaSel', homeBloc.coloniaotroValue!);
                                    homeBloc.coloniaSelectedNext('COL ${homeBloc.coloniaotroValue!}');
                                  }, 
                                  label: 'Guardar', 
                                  stream: homeBloc.formulario1Stream
                                ),
                                SizedBox(height: 20),
                              },
                              if(colonia == 'Agregar ejido') ...{
                                EncabezadoWidget(encabezdo: 'Agregar ejido*'),
                                InputWidget(
                                  textCapitalization: true,
                                  textEditingController: homeBloc.coloniaotroControllerValue, 
                                  value: homeBloc.coloniaotroValue, 
                                  stream: homeBloc.coloniaotro, 
                                  next: homeBloc.coloniaotroNext
                                ),
                                SizedBox(height: 20),
                                BotonWidget(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    addlog(accion: 'Agregar', apartado: 'Inicio', descripcion: 'Agrego un ejido manualmente');
                                    await prefs.setString('coloniaSel', homeBloc.coloniaotroValue!);
                                    homeBloc.coloniaSelectedNext('EJ ${homeBloc.coloniaotroValue!}');
                                  }, 
                                  label: 'Guardar', 
                                  stream: homeBloc.formulario1Stream
                                ),
                                SizedBox(height: 20),
                              }
                            ],
                          );
                        }
                      );
                    }
                  ),
                  StreamBuilder(
                    stream: homeBloc.calles,
                    builder: (context, snapshot) {
                      List<String> items = [];
                      if(snapshot.hasData) {
                        items = snapshot.data!;
                      }
                      return items.isEmpty ? SizedBox() : StreamBuilder(
                        stream: homeBloc.calleSelected,
                        builder: (context, snapshot) {
                          String calle = '';
                          if(snapshot.hasData) {
                            calle = snapshot.data!;
                          }
                          return Column(
                            children: [
                              if(items[0] != 'Otro') ...{
                                _containerCalle(items),
                              },
                              if(calle == 'Otro' || items[0] == 'Otro') ...{
                                EncabezadoWidget(encabezdo: 'Otro*'),
                                InputWidget(
                                  textCapitalization: true,
                                  textEditingController: homeBloc.calleotroControllerValue, 
                                  value: homeBloc.calleotroValue, 
                                  stream: homeBloc.calleotro, 
                                  next: homeBloc.calleotroNext
                                ),
                                SizedBox(height: 20),
                                BotonWidget(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    addlog(accion: 'Agregar', apartado: 'Inicio', descripcion: 'Agrego una calle manualmente');
                                    await prefs.setString('calleSel', homeBloc.calleotroValue!);
                                    homeBloc.calleSelectedNext(homeBloc.calleotroValue!);
                                  }, 
                                  label: 'Guardar', 
                                  stream: homeBloc.formulario1Stream
                                ),
                                SizedBox(height: 20),
                              }
                            ],
                          );
                        }
                      );
                    }
                  ),
                  EncabezadoWidget(encabezdo: 'Número de casa'),
                  InputWidget(
                    textCapitalization: true,
                    textEditingController: homeBloc.numeroControllerValue, 
                    value: homeBloc.numeroValue, 
                    stream: homeBloc.numero, 
                    next: homeBloc.numeroNext,
                    textInputType: TextInputType.streetAddress,
                    maxLength: 4,
                  ),
                ],
              )
            )
          : SizedBox();
        }
      ),
    );
  }

  Widget _button2(String text, bool local) {
    return SizedBox(
      height: 120,
      width: sizeTotalWidth(context),
      child: Card(
        color: Color(0xfb691c32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              ),
            ),
            if(local) ...[

            StreamBuilder(
              stream: DatabaseProvider.db.obtenerEncuestasCount().asStream(), 
              builder: (context, snapshot) {
                int count = 0;
                if(snapshot.hasData) {
                  count = snapshot.data!;
                }
                return Text(
                  'Total locales: $count ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                  ),
                );
              }
            )
            ]
          ],
        ),
      ),
    );
  }

  
   Future<void> dialog(int count) async {
    await Dialogs.materialDialog(
      title: "¿Desea enviar la informacion?",
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
            Navigator.of(context).pop();
            sendSincronizar();
          },
          text: "Enviar",
          iconData: Icons.send_outlined,
          color: primaryColor,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
  }

   Future<void> sendSincronizar() async {
    homeBloc.mostrarCircularProgressNext(true);
    List<Formulario> encuestas = await DatabaseProvider.db.getEncuestados();
    if(encuestas.isNotEmpty) {
      for(int i = 0; i < encuestas.length; i++) {
        await EncuestaServices.instance.sincronizar(form: encuestas[i]);
      }
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBarWidget.instance.snackBarSuccess(message: 'Informacion enviada'));
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => HomeScreen()), (route) => false);
    homeBloc.mostrarCircularProgressNext(false);
  }
}