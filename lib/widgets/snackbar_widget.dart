import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SnackBarWidget{
  
  SnackBarWidget._();
  static final SnackBarWidget instance = SnackBarWidget._();
  
  SnackBar snackBarError({
    required String message
  }) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error',
        message: message,
        contentType: ContentType.failure,
      ),
    );
  }

  SnackBar snackBarSuccess({
    required String message
  }) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Exito',
        message: message,
        contentType: ContentType.success,
      ),
    );
  }

  SnackBar snackBarWarning({
    required String message
  }) {
    return SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Aviso',
        message: message,
        contentType: ContentType.warning,
      ),
    );
  }
}  