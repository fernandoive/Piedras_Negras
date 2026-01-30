import 'package:data_analitica_2/util/utils.dart';
import 'package:flutter/material.dart';

class BotonWidgetNormal extends StatefulWidget {

  final VoidCallback onPressed;
  final String label;
  final bool enable;
  final double? width;
  final Color? color;

  const BotonWidgetNormal({
    required this.onPressed,
    required this.label,
    required this.enable,
    this.width,
    this.color,
    super.key
  });

  @override
  State<BotonWidgetNormal> createState() => _BotonWidgetNormalState();
}

class _BotonWidgetNormalState extends State<BotonWidgetNormal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? sizeWidth(context),
      height: 50,
      child: ElevatedButton(
        onPressed: widget.enable ? widget.onPressed : null,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(15),
          backgroundColor: WidgetStateProperty.all( 
            widget.enable ? widget.color : Colors.grey),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          )
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 17,
            color:Colors.white,
          ),
        ),
      ),
    );
  }
}