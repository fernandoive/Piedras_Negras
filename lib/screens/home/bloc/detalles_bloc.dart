import 'package:data_analitica_2/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DetallesBloc extends Validators {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);
  final _rol = BehaviorSubject<String>();
  final _nombre = BehaviorSubject<String>();
  final _apellidoP = BehaviorSubject<String>();
  final _apellidoM = BehaviorSubject<String>();
  final _dv = BehaviorSubject<String>();
  final _mov = BehaviorSubject<String>();
  final _comite = BehaviorSubject<String>();
  final _cuantos = BehaviorSubject<String>();
  final _observaciones = BehaviorSubject<String>();
  final _amigos = BehaviorSubject<String>();
  final _telefono= BehaviorSubject<String>();
  final _municipio= BehaviorSubject<String>();
  final _colonia= BehaviorSubject<String>();
  final _calle= BehaviorSubject<String>();
  final _numExt= BehaviorSubject<String>();
  final _numInt= BehaviorSubject<String>();
  final _cp= BehaviorSubject<String>();

  final _cuantosController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _observacionesController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _amigosController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _nombreController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _apellidoMController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _apellidoPController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _telefonoController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _municipioController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _coloniaController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _calleController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _numExtController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _numIntController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _cpController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());


  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  TextEditingController get apellidoMControllerValue => _apellidoMController.value;
  Stream<String> get apellidoM => _apellidoM.stream.transform(validarNombre);
  String? get apellidoMValue => _apellidoM.valueOrNull;
  apellidoMNext(String apellidoM) {
    _apellidoM.sink.add(apellidoM);
  }

  TextEditingController get apellidoPControllerValue => _apellidoPController.value;
  Stream<String> get apellidoP => _apellidoP.stream.transform(validarNombre);
  String? get apellidoPValue => _apellidoP.valueOrNull;
  apellidoPNext(String apellidoP) {
    _apellidoP.sink.add(apellidoP);
  }

  TextEditingController get nombreControllerValue => _nombreController.value;
  Stream<String> get nombre => _nombre.stream.transform(validarNombre);
  String? get nombreValue => _nombre.valueOrNull;
  nombreNext(String nombre) {
    _nombre.sink.add(nombre);
  }

  TextEditingController get amigosControllerValue => _amigosController.value;
  Stream<String> get amigos => _amigos.stream;
  String? get amigosValue => _amigos.valueOrNull;
  amigosNext(String amigos) {
    _amigos.sink.add(amigos);
  }

  TextEditingController get observacionesControllerValue => _observacionesController.value;
  Stream<String> get observaciones => _observaciones.stream;
  String? get observacionesValue => _observaciones.valueOrNull;
  observacionesNext(String observaciones) {
    _observaciones.sink.add(observaciones);
  }

  TextEditingController get telefonoControllerValue => _telefonoController.value;
  Stream<String> get telefono => _telefono.stream.transform(validarPhone);
  String? get telefonoValue => _telefono.valueOrNull;
  telefonoNext(String telefono) {
    _telefono.sink.add(telefono);
  }

  TextEditingController get cuantosControllerValue => _cuantosController.value;
  Stream<String> get cuantos => _cuantos.stream;
  String? get cuantosValue => _cuantos.valueOrNull;
  cuantosNext(String cuantos) {
    _cuantos.sink.add(cuantos);
  }

  TextEditingController get municipioControllerValue => _municipioController.value;
  Stream<String> get municipio => _municipio.stream;
  String? get municipioValue => _municipio.valueOrNull;
  municipioNext(String municipio) {
    _municipio.sink.add(municipio);
  }

  TextEditingController get coloniaControllerValue => _coloniaController.value;
  Stream<String> get colonia => _colonia.stream;
  String? get coloniaValue => _colonia.valueOrNull;
  coloniaNext(String colonia) {
    _colonia.sink.add(colonia);
  }

  TextEditingController get calleControllerValue => _calleController.value;
  Stream<String> get calle => _calle.stream;
  String? get calleValue => _calle.valueOrNull;
  calleNext(String calle) {
    _calle.sink.add(calle);
  }

  TextEditingController get cpControllerValue => _cpController.value;
  Stream<String> get cp => _cp.stream;
  String? get cpValue => _cp.valueOrNull;
  cpNext(String cp) {
    _cp.sink.add(cp);
  }

  TextEditingController get numExtControllerValue => _numExtController.value;
  Stream<String> get numExt => _numExt.stream;
  String? get numExtValue => _numExt.valueOrNull;
  numExtNext(String numExt) {
    _numExt.sink.add(numExt);
  }

  TextEditingController get numIntControllerValue => _numIntController.value;
  Stream<String> get numInt => _numInt.stream;
  String? get numIntValue => _numInt.valueOrNull;
  numIntNext(String numInt) {
    _numInt.sink.add(numInt);
  }

  Stream<String> get rol => _rol.stream;
  String? get rolValue => _rol.valueOrNull;
  rolNext(String rol) {
    _rol.sink.add(rol);
  }

  Stream<String> get dv => _dv.stream;
  String? get dvValue => _dv.valueOrNull;
  dvNext(String dv) {
    _dv.sink.add(dv);
  }

  Stream<String> get mov => _mov.stream;
  String? get movValue => _mov.valueOrNull;
  movNext(String mov) {
    _mov.sink.add(mov);
  }

  Stream<String> get comite => _comite.stream;
  String? get comiteValue => _comite.valueOrNull;
  comiteNext(String comite) {
    _comite.sink.add(comite);
  }

  Stream<bool> get formularioStream =>
  Rx.combineLatest([
    rol,
    nombre,
    apellidoP,
    apellidoM,
    dv,
    mov,
    cuantos,
    observaciones,
    amigos,
    telefono,
    comite,
    colonia,
    calle,
    municipio,
    cp
  ], (List<dynamic> streams) {
  if ((streams[0] == _rol.value) &&
     (streams[1] == _nombre.value) &&
     (streams[2] == _apellidoP.value) &&
     (streams[3] == _apellidoM.value) &&
     (streams[4] == _dv.value) &&
     (streams[5] == _mov.value) &&
     (streams[6] == _cuantos.value) &&
     (streams[7] == _observaciones.value) &&
     (streams[8] == _amigos.value) &&
     (streams[9] == _telefono.value) &&
     (streams[10] == _comite.value) &&
     (streams[11] == _colonia.value) &&
     (streams[12] == _calle.value) &&
     (streams[13] == _municipio.value) &&
     (streams[14] == _cp.value)
     ) {
    return true;
  }
    return false;
  });


  dispose() {
    _mostrarCircularProgress.close();
    _rol.close();
    _nombre.close();
    _apellidoP.close();
    _apellidoM.close();
    _dv.close();
    _mov.close();
    _cuantos.close();
    _observaciones.close();
    _amigos.close();
    _telefono.close();
    _comite.close();
    _municipio.close();
    _colonia.close();
    _calle.close();
    _numExt.close();
    _numInt.close();
    _cp.close();

    _cuantosController.close();
    _cuantosController.value.dispose();
    _observacionesController.close();
    _observacionesController.value.dispose();
    _amigosController.close();
    _amigosController.value.dispose();
    _nombreController.close();
    _nombreController.value.dispose();
    _apellidoMController.close();
    _apellidoMController.value.dispose();
    _apellidoPController.close();
    _apellidoPController.value.dispose();
    _telefonoController.close();
    _telefonoController.value.dispose();

    _municipioController.close();
    _municipioController.value.dispose();
    _coloniaController.close();
    _coloniaController.value.dispose();
    _calleController.close();
    _calleController.value.dispose();
    _numExtController.close();
    _numExtController.value.dispose();
    _numIntController.close();
    _numIntController.value.dispose();
    _cpController.close();
    _cpController.value.dispose();
  }

}