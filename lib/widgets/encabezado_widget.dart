import 'package:data_analitica_2/util/constantes.dart';
import 'package:flutter/material.dart';

class EncabezadoWidget extends StatefulWidget {
  final String encabezdo;
  const EncabezadoWidget({
    super.key,
    required this.encabezdo
  });

  @override
  State<EncabezadoWidget> createState() => _EncabezadoWidgetState();
}

class _EncabezadoWidgetState extends State<EncabezadoWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
            child: Text(
              widget.encabezdo.toUpperCase(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 15.0),
            ),
          ),
        )
      ],
    );
  }
}