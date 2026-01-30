import 'dart:async';

class Validators{
  // Crear regExp
  // Email:
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  // Password:
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  // Phone:
  static final RegExp _phoneRegExp = RegExp(
    '[6-9]\\d{9}',
  );

  // 2 funciones:
  // isValidEmail
  static isValidEmail(String email){
    return _emailRegExp.hasMatch(email);
  }

  // isValidPassword
  static isValidPassword(String password){
    return _passwordRegExp.hasMatch(password);
  }

  // isValidPhone
  static isValidPhone(String phone){
    return _phoneRegExp.hasMatch(phone);
  }

  final validarCorreo = StreamTransformer<String, String>.fromHandlers(
      handleData: (correo, sink) {
    if (!isValidEmail(correo)) {
      sink.addError('Correo invalido');
    } else {
      sink.add(correo);
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (!isValidPassword(password)) {
      sink.addError('Contraseña invalido');
    } else {
      sink.add(password);
    }
  });

  final validarPhone = StreamTransformer<String, String>.fromHandlers(
      handleData: (phone, sink) {
    if (phone.length < 10) {
      sink.addError('Telefono invalido');
    } else {
      sink.add(phone);
    }
  });

  final validarEdad = StreamTransformer<String, String>.fromHandlers(
      handleData: (edad, sink) {
    if (int.parse(edad) > 100) {
      sink.addError('Edad invalida');
    } else {
      sink.add(edad);
    }
  });

  final validarDia = StreamTransformer<String, String>.fromHandlers(
      handleData: (dia, sink) {
    if (int.parse(dia) < 1900 && int.parse(dia) > 31) {
      sink.addError('Dia invalida');
    } else {
      sink.add(dia);
    }
  });

  final validarAno = StreamTransformer<String, String>.fromHandlers(
      handleData: (ano, sink) {
    if (int.parse(ano) > DateTime.now().year) {
      sink.addError('Ano invalida');
    } else {
      sink.add(ano);
    }
  });

  final validarDomicilio = StreamTransformer<String, String>.fromHandlers(
      handleData: (domicilio, sink) {
    if (domicilio.length < 10) {
      sink.addError('Domicilio invalido');
    } else {
      sink.add(domicilio);
    }
  });

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.length < 1) {
      sink.addError('Nombre invalido');
    } else {
      sink.add(nombre);
    }
  });
}