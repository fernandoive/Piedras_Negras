import 'package:data_analitica_2/util/utils.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  
  final TextEditingController textEditingController;
  final String? value;
  final Stream<String> stream;
  final Function(String) next;
  
  final TextInputType? textInputType;
  final String? label; 
  final String? hint;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool? password;
  final bool? obscureText;
  final int? maxLength;
  final bool? textCapitalization;
  final double? width;
  
  const InputWidget({
    required this.textEditingController,
    required this.value,
    required this.stream,
    required this.next,
    this.textInputType,
    this.label,
    this.hint,
    this.suffixIcon,
    this.onPressed,
    this.icon,
    this.password,
    this.obscureText,
    this.maxLength,
    this.textCapitalization,
    this.width,
    super.key
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.textEditingController;
    String? value = widget.value;

    if (value != null) {
      _controller.text = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        String error = '';
        if(snapshot.hasError) {
          error = snapshot.error!.toString();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              width: widget.width ?? sizeWidth(context),
              child: TextFormField(
                textCapitalization: widget.textCapitalization == null ? TextCapitalization.none : TextCapitalization.characters,
                obscureText: widget.password == null ? 
                    false : widget.obscureText!,
                controller: _controller,
                maxLength: widget.maxLength,
                keyboardType: widget.textInputType ?? TextInputType.text,
                decoration: InputDecoration(
                  errorText: error.isEmpty ? null : error,
                  isDense: true,
                  prefixIcon: widget.icon == null ?
                    null : Icon(widget.icon, color: Colors.grey[400],),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(250, 26, 8, 106), width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
                  ),
                  disabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
                  ),
                  labelText: widget.label ?? '',
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Color.fromARGB(250, 26, 8, 106),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
                  ),
                  suffixIcon: widget.password == null ?
                      null : IconButton(
                    icon: Icon(
                      !widget.obscureText! ? Icons.visibility_off_outlined : Icons.visibility_outlined,color: Color.fromARGB(250, 26, 8, 106),
                    ),
                    onPressed: widget.onPressed,
                  ),
                ),
                onChanged: (String value) => widget.next(value),
              ),
            ),
          ],
        );
      }
    );
  }
}