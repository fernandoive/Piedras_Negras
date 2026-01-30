import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util/validators.dart';

class EncuestadoBloc extends Validators {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);

  final _apellidoMaterno = BehaviorSubject<String>();
  final _apellidoPaterno = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _name = BehaviorSubject<String>();
  final _numero = BehaviorSubject<String>();
  final _colonia = BehaviorSubject<String>();
  final _calle = BehaviorSubject<String>();
  
  final _apellidoMaternoController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _apellidoPaternoController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _phoneController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _nameController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _numeroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _coloniaController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _calleController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());

  final _pregunta1 = BehaviorSubject<String>();
  final _pregunta2 = BehaviorSubject<String>();
  final _pregunta3 = BehaviorSubject<String>();
  final _pregunta4 = BehaviorSubject<String>();

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  //////////////////////////////////////////////////
  ///       apellidoMaterno
  //////////////////////////////////////////////////
  Stream<String> get apellidoMaterno => _apellidoMaterno.stream.transform(validarNombre);

  String? get apellidoMaternoValue => _apellidoMaterno.valueOrNull;

  apellidoMaternoNext(String apellidoMaterno) {
    _apellidoMaterno.sink.add(apellidoMaterno);
  }

  //////////////////////////////////////////////////
  ///       apellidoMaternoController
  //////////////////////////////////////////////////
  TextEditingController get apellidoMaternoControllerValue =>
      _apellidoMaternoController.value;

  //////////////////////////////////////////////////
  ///       apellidoPaterno
  //////////////////////////////////////////////////
  Stream<String> get apellidoPaterno => _apellidoPaterno.stream.transform(validarNombre);

  String? get apellidoPaternoValue => _apellidoPaterno.valueOrNull;

  apellidoPaternoNext(String apellidoPaterno) {
    _apellidoPaterno.sink.add(apellidoPaterno);
  }

    //////////////////////////////////////////////////
  ///       apellidoPaternoController
  //////////////////////////////////////////////////
  TextEditingController get apellidoPaternoControllerValue =>
      _apellidoPaternoController.value;

  //////////////////////////////////////////////////
  ///       phoneController
  //////////////////////////////////////////////////
  TextEditingController get phoneControllerValue =>
      _phoneController.value;
  
  //////////////////////////////////////////////////
  ///       phone
  //////////////////////////////////////////////////
  Stream<String> get phone => _phone.stream.transform(validarPhone);

  String? get phoneValue => _phone.valueOrNull;

  phoneNext(String phone) {
    _phone.sink.add(phone);
  }

  //////////////////////////////////////////////////
  ///       nameController
  //////////////////////////////////////////////////
  TextEditingController get nameControllerValue =>
      _nameController.value;

  //////////////////////////////////////////////////
  ///       name
  //////////////////////////////////////////////////
  Stream<String> get name => _name.stream.transform(validarNombre);

  String? get nameValue => _name.valueOrNull;

  nameNext(String name) {
    _name.sink.add(name);
  }

  //////////////////////////////////////////////////
  ///       pregunta1
  //////////////////////////////////////////////////
  Stream<String> get pregunta1 => _pregunta1.stream;

  String? get pregunta1Value => _pregunta1.valueOrNull;

  pregunta1Next(String pregunta1) {
    _pregunta1.sink.add(pregunta1);
  }

  //////////////////////////////////////////////////
  ///       pregunta2
  //////////////////////////////////////////////////
  Stream<String> get pregunta2 => _pregunta2.stream;

  String? get pregunta2Value => _pregunta2.valueOrNull;

  pregunta2Next(String pregunta2) {
    _pregunta2.sink.add(pregunta2);
  }

  //////////////////////////////////////////////////
  ///       pregunta3
  //////////////////////////////////////////////////
  Stream<String> get pregunta3 => _pregunta3.stream;

  String? get pregunta3Value => _pregunta3.valueOrNull;

  pregunta3Next(String pregunta3) {
    _pregunta3.sink.add(pregunta3);
  }

  //////////////////////////////////////////////////
  ///       pregunta4
  //////////////////////////////////////////////////
  Stream<String> get pregunta4 => _pregunta4.stream;

  String? get pregunta4Value => _pregunta4.valueOrNull;

  pregunta4Next(String pregunta4) {
    _pregunta4.sink.add(pregunta4);
  }

    //////////////////////////////////////////////////
  ///       calle
  //////////////////////////////////////////////////
  Stream<String> get calle => _calle.stream;

  String? get calleValue => _calle.valueOrNull;

  calleNext(String calle) {
    _calle.sink.add(calle);
  }

  //////////////////////////////////////////////////
  ///       colonia
  //////////////////////////////////////////////////
  Stream<String> get colonia => _colonia.stream;

  String? get coloniaValue => _colonia.valueOrNull;

  coloniaNext(String colonia) {
    _colonia.sink.add(colonia);
  }

  //////////////////////////////////////////////////
  ///       numero
  //////////////////////////////////////////////////
  Stream<String> get numero => _numero.stream;

  String? get numeroValue => _numero.valueOrNull;

  numeroNext(String numero) {
    _numero.sink.add(numero);
  }

 //////////////////////////////////////////////////
  ///       coloniaController
  //////////////////////////////////////////////////
  TextEditingController get coloniaControllerValue =>
      _coloniaController.value;

 //////////////////////////////////////////////////
  ///       calleController
  //////////////////////////////////////////////////
  TextEditingController get calleControllerValue =>
      _calleController.value;

 //////////////////////////////////////////////////
  ///       numeroController
  //////////////////////////////////////////////////
  TextEditingController get numeroControllerValue =>
      _numeroController.value;

  //////////////////////////////////////////////////
  ///       formularioLoginStream
  //////////////////////////////////////////////////
  Stream<bool> get formularioCandidatoStream =>
  Rx.combineLatest([
    pregunta1, 
    pregunta2,
    pregunta3,
  ], (List<dynamic> streams) {
  if ((streams[0] == _pregunta1.value) &&
      (streams[1] == _pregunta2.value) &&
      (streams[2] == _pregunta3.value)) {
      return true;
    }
    return false;
  });

  //////////////////////////////////////////////////
  ///       formularioStream
  //////////////////////////////////////////////////
 Stream<bool> get formularioStream =>
  Rx.combineLatest([
    name,
    apellidoPaterno, 
    apellidoMaterno,
    phone
  ], (List<dynamic> streams) {
  if ((streams[0] == _name.value) &&
     (streams[1] == _apellidoPaterno.value) &&
     (streams[2] == _apellidoMaterno.value) &&
     (streams[3] == _phone.value)
  ) {
    return true;
  }
    return false;
  });

  dispose() {
    _mostrarCircularProgress.close();
    _apellidoMaterno.close();
    _apellidoPaterno.close();
    _phone.close();
    _name.close();
    _apellidoMaternoController.value.dispose();
    _apellidoMaternoController.close();
    _apellidoPaternoController.value.dispose();
    _apellidoPaternoController.close();

    _phoneController.value.dispose();
    _phoneController.close();
    _nameController.value.dispose();
    _nameController.close();
  }

}