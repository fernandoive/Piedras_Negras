import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util/validators.dart';

class EncuestaBloc extends Validators {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);

  final _p2otro = BehaviorSubject<String>.seeded('');
  final _p4otro = BehaviorSubject<String>.seeded('');
  final _p7otro = BehaviorSubject<String>.seeded('');
  final _name = BehaviorSubject<String>();
  final _numero = BehaviorSubject<String>();
  final _colonia = BehaviorSubject<String>();
  final _calle = BehaviorSubject<String>();
  
  final _p2otroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _p4otroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _p7otroController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  final _nameController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());

  final _pregunta1 = BehaviorSubject<String>();
  final _pregunta2 = BehaviorSubject<String>();
  final _pregunta3 = BehaviorSubject<String>();
  final _pregunta4 = BehaviorSubject<String>();
  final _pregunta5 = BehaviorSubject<String>();
  final _pregunta6 = BehaviorSubject<String>();
  final _pregunta7 = BehaviorSubject<String>();
  final _pregunta8 = BehaviorSubject<String>();
  final _pregunta9 = BehaviorSubject<String>();
  final _pregunta10 = BehaviorSubject<String>();
  final _pregunta11 = BehaviorSubject<String>();

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  //////////////////////////////////////////////////
  ///       p2otro
  //////////////////////////////////////////////////
  Stream<String> get p2otro => _p2otro.stream;

  String? get p2otroValue => _p2otro.valueOrNull;

  p2otroNext(String p2otro) {
    _p2otro.sink.add(p2otro);
  }

  //////////////////////////////////////////////////
  ///       p2otroController
  //////////////////////////////////////////////////
  TextEditingController get p2otroControllerValue =>
      _p2otroController.value;

  //////////////////////////////////////////////////
  ///       p4otro
  //////////////////////////////////////////////////
  Stream<String> get p4otro => _p4otro.stream;

  String? get p4otroValue => _p4otro.valueOrNull;

  p4otroNext(String p4otro) {
    _p4otro.sink.add(p4otro);
  }

    //////////////////////////////////////////////////
  ///       p4otroController
  //////////////////////////////////////////////////
  TextEditingController get p4otroControllerValue =>
      _p4otroController.value;

  //////////////////////////////////////////////////
  ///       p7otroController
  //////////////////////////////////////////////////
  TextEditingController get p7otroControllerValue =>
      _p7otroController.value;
  
  //////////////////////////////////////////////////
  ///       p7otro
  //////////////////////////////////////////////////
  Stream<String> get p7otro => _p7otro.stream;

  String? get p7otroValue => _p7otro.valueOrNull;

  p7otroNext(String p7otro) {
    _p7otro.sink.add(p7otro);
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
  ///       pregunta5
  //////////////////////////////////////////////////
  Stream<String> get pregunta5 => _pregunta5.stream;

  String? get pregunta5Value => _pregunta5.valueOrNull;

  pregunta5Next(String pregunta5) {
    _pregunta5.sink.add(pregunta5);
  }

  //////////////////////////////////////////////////
  ///       pregunta5
  //////////////////////////////////////////////////
  Stream<String> get pregunta6 => _pregunta6.stream;

  String? get pregunta6Value => _pregunta6.valueOrNull;

  pregunta6Next(String pregunta6) {
    _pregunta6.sink.add(pregunta6);
  }

  //////////////////////////////////////////////////
  ///       pregunta7
  //////////////////////////////////////////////////
  Stream<String> get pregunta7 => _pregunta7.stream;

  String? get pregunta7Value => _pregunta7.valueOrNull;

  pregunta7Next(String pregunta7) {
    _pregunta7.sink.add(pregunta7);
  }

  //////////////////////////////////////////////////
  ///       pregunta8
  //////////////////////////////////////////////////
  Stream<String> get pregunta8 => _pregunta8.stream;

  String? get pregunta8Value => _pregunta8.valueOrNull;

  pregunta8Next(String pregunta8) {
    _pregunta8.sink.add(pregunta8);
  }

  //////////////////////////////////////////////////
  ///       pregunta9
  //////////////////////////////////////////////////
  Stream<String> get pregunta9 => _pregunta9.stream;

  String? get pregunta9Value => _pregunta9.valueOrNull;

  pregunta9Next(String pregunta9) {
    _pregunta9.sink.add(pregunta9);
  }

  //////////////////////////////////////////////////
  ///       pregunta10
  //////////////////////////////////////////////////
  Stream<String> get pregunta10 => _pregunta10.stream;

  String? get pregunta10Value => _pregunta10.valueOrNull;

  pregunta10Next(String pregunta10) {
    _pregunta10.sink.add(pregunta10);
  }

  //////////////////////////////////////////////////
  ///       pregunta11
  //////////////////////////////////////////////////
  Stream<String> get pregunta11 => _pregunta11.stream;

  String? get pregunta11Value => _pregunta11.valueOrNull;

  pregunta11Next(String pregunta11) {
    _pregunta11.sink.add(pregunta11);
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
  ///       formularioLoginStream
  //////////////////////////////////////////////////
  Stream<bool> get formularioCandidatoStream =>
  Rx.combineLatest([
    pregunta1, 
    pregunta2,
    pregunta3,
    pregunta4,
    pregunta5,
    pregunta6,
    pregunta7,
    pregunta8,
    pregunta9,
    pregunta10,
    pregunta11,
    p2otro,
    p4otro,
    p7otro
  ], (List<dynamic> streams) {
    final otro2Valido = streams[1] == 'Otro'
    ? (streams[11] != null && streams[11].trim().isNotEmpty)
    : true;

    final otro4Valido = streams[3] == 'Otro'
    ? (streams[12] != null && streams[12].trim().isNotEmpty)
    : true;

    final otro7Valido = streams[6] == 'Otro'
    ? (streams[13] != null && streams[13].trim().isNotEmpty)
    : true;

  if ((streams[0] == _pregunta1.value) &&
      (streams[1] == _pregunta2.value) &&
      (streams[2] == _pregunta3.value) &&
      (streams[3] == _pregunta4.value) &&
      (streams[4] == _pregunta5.value) &&
      (streams[5] == _pregunta6.value) &&
      (streams[6] == _pregunta7.value) &&
      (streams[7] == _pregunta8.value) &&
      (streams[8] == _pregunta9.value) &&
      (streams[9] == _pregunta10.value) &&
      (streams[10] == _pregunta11.value) &&
      (otro2Valido) &&
      (otro4Valido) &&
      (otro7Valido)
      ) {
      return true;
    }
    return false;
  });

 
  dispose() {
    _mostrarCircularProgress.close();
    _p2otro.close();
    _p4otro.close();
    _p7otro.close();
    _name.close();
    _p2otroController.value.dispose();
    _p2otroController.close();
    _p4otroController.value.dispose();
    _p4otroController.close();

    _p7otroController.value.dispose();
    _p7otroController.close();
    _nameController.value.dispose();
    _nameController.close();
  }

}