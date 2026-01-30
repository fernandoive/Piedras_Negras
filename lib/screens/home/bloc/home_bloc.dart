import 'package:data_analitica_2/models/seccion_model.dart';
import 'package:data_analitica_2/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);
  final _button = BehaviorSubject<bool>.seeded(true);

  final _user = BehaviorSubject<UserModel>.seeded(UserModel());
  final _sesion = BehaviorSubject<SeccionModel>.seeded(SeccionModel());
  final _seccion = BehaviorSubject<String>();
  final _seccionSave = BehaviorSubject<bool>.seeded(false);
  final _seccionesActivas = BehaviorSubject<List<SeccionModel>>.seeded([]);

  final _coloniaSelected = BehaviorSubject<String>.seeded(''); 
  final _calleSelected = BehaviorSubject<String>.seeded(''); 

  final _colonias = BehaviorSubject<List<String>>(); 
  final _calles = BehaviorSubject<List<String>>();

  final _activo = BehaviorSubject<bool>.seeded(false);

  final _coloniaotro = BehaviorSubject<String>.seeded('');
  final _calleotro = BehaviorSubject<String>.seeded('');

  final _coloniaotroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _calleotroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _numero = BehaviorSubject<String>();
  final _numeroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  
   Stream<List<SeccionModel>> get seccionesActivas => _seccionesActivas.stream;

  List<SeccionModel> get seccionesActivasValue => _seccionesActivas.value;

  seccionesActivasNext(List<SeccionModel> seccionesActivas) {
    _seccionesActivas.sink.add(seccionesActivas);
  }

  TextEditingController get coloniaotroControllerValue =>
      _coloniaotroController.value;
  
  TextEditingController get calleotroControllerValue =>
      _calleotroController.value;

  TextEditingController get numeroControllerValue =>
      _numeroController.value;

  Stream<String> get numero => _numero.stream;
  String? get numeroValue => _numero.valueOrNull;
  numeroNext(String numero) {
    _numero.sink.add(numero);
  }

  Stream<String> get coloniaotro => _coloniaotro.stream;
  String? get coloniaotroValue => _coloniaotro.valueOrNull;
  coloniaotroNext(String coloniaotro) {
    _coloniaotro.sink.add(coloniaotro);
  }

  Stream<String> get calleotro => _calleotro.stream;
  String? get calleotroValue => _calleotro.valueOrNull;
  calleotroNext(String calleotro) {
    _calleotro.sink.add(calleotro);
  }

  //////////////////////////////////////////////////
  ///       activo
  //////////////////////////////////////////////////
  Stream<bool> get activo => _activo.stream;

  bool? get activoValue => _activo.valueOrNull;

  activoNext(bool activo) {
    _activo.sink.add(activo);
  }
  
  //////////////////////////////////////////////////
  ///       seccion
  //////////////////////////////////////////////////
  Stream<String> get seccion => _seccion.stream;

  String? get seccionValue => _seccion.valueOrNull;

  seccionNext(String seccion) {
    _seccion.sink.add(seccion);
  }

  //////////////////////////////////////////////////
  ///       seccionSave
  //////////////////////////////////////////////////
  Stream<bool> get seccionSave => _seccionSave.stream;

  bool? get seccionSaveValue => _seccionSave.valueOrNull;

  seccionSaveNext(bool seccionSave) {
    _seccionSave.sink.add(seccionSave);
  }

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  //////////////////////////////////////////////////
  ///       button
  //////////////////////////////////////////////////
  Stream<bool> get button => _button.stream;

  bool get buttonValue => _button.value;

  buttonNext(bool button) {
    _button.sink.add(button);
  }

  //////////////////////////////////////////////////
  ///       user
  //////////////////////////////////////////////////
  Stream<UserModel> get user => _user.stream;

  UserModel get userValue => _user.value;

  userNext(UserModel user) {
    _user.sink.add(user);
  }

  //////////////////////////////////////////////////
  ///       user
  //////////////////////////////////////////////////
  Stream<SeccionModel> get sesion => _sesion.stream;

  SeccionModel get sesionValue => _sesion.value;

  sesionNext(SeccionModel sesion) {
    _sesion.sink.add(sesion);
  }

  Stream<String> get calleSelected => _calleSelected.stream;
  String? get calleSelectedValue => _calleSelected.valueOrNull;
  calleSelectedNext(String calleSelected) {
    _calleSelected.sink.add(calleSelected);
  }

  Stream<String> get coloniaSelected => _coloniaSelected.stream;
  String? get coloniaSelectedValue => _coloniaSelected.valueOrNull;
  coloniaSelectedNext(String coloniaSelected) {
    _coloniaSelected.sink.add(coloniaSelected);
  }

  Stream<List<String>> get calles => _calles.stream;
  List<String>? get callesValue => _calles.valueOrNull;
  callesNext(List<String> calles) {
    _calles.sink.add(calles);
  }

  Stream<List<String>> get colonias => _colonias.stream;
  List<String>? get coloniasValue => _colonias.valueOrNull;
  coloniasNext(List<String> colonias) {
    _colonias.sink.add(colonias);
  }

  Stream<bool> get formulario1Stream =>
  Rx.combineLatest([
    coloniaotro,
  ], (List<dynamic> streams) {
  if ((streams[0] == _coloniaotro.value)
  ) {
    return true;
  }
    return false;
  });

  Stream<bool> get formulario2Stream =>
  Rx.combineLatest([
    calleotro,
  ], (List<dynamic> streams) {
  if ((streams[0] == _calleotro.value)
  ) {
    return true;
  }
    return false;
  });


  dispose() {
    _mostrarCircularProgress.close();
    _user.close();
    _calleSelected.close();
    _calles.close();
    _coloniaSelected.close();
    _colonias.close();
    _sesion.close();
    _seccion.close();
    _seccionSave.close();
  }

}