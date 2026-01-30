import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/util/utils.dart';
import 'package:flutter/material.dart';

class BotonWidget extends StatefulWidget {

  final VoidCallback onPressed;
  final String label;
  final Stream<bool> stream;
  final double? width;

  const BotonWidget({
    required this.onPressed,
    required this.label,
    required this.stream,
    this.width,
    super.key
  });

  @override
  State<BotonWidget> createState() => _BotonWidgetState();
}

class _BotonWidgetState extends State<BotonWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        bool enable = false;
        if(snapshot.hasData) {
          enable = snapshot.data!;
        }

        return SizedBox(
          width: widget.width ?? sizeWidth(context),
          height: 50,
          child: ElevatedButton(
            onPressed: enable ? widget.onPressed : null,
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(15),
              backgroundColor: WidgetStateProperty.all( 
                enable ? butonColor : Colors.grey),
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
    );
  }
}