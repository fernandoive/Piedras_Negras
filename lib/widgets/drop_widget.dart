import 'package:data_analitica_2/util/constantes.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropWidget extends StatefulWidget {
  final Function(String) next;
  final String? value;
  final Stream<String> stream;
  final List<String>? listItems;
  final double? width;
  final String? label;
  const DropWidget({
    super.key,
    required this.next,
    required this.value,
    required this.stream,
    this.listItems,
    this.width,
    this.label,
  });

  @override
  State<DropWidget> createState() => _DropWidgetState();
}

class _DropWidgetState extends State<DropWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.stream,
      builder: (context, snapshot) {
        return Container(
          height: 70,
          width: widget.width ?? double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: DropdownSearch<String>(
            items: widget.listItems == null ? encuesta : widget.listItems!,
            clearButtonProps: ClearButtonProps(
              icon: Icon(Icons.clear)
            ),
            selectedItem: widget.value,
            validator: (v) => v == null ? "Campo requerido" : null,
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: widget.label ?? "",
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 1),
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
                  floatingLabelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 212, 212, 212), width: 1),
                  ),
                  ),
                ),
            onChanged: (value) {
              widget.next(value!);
            },
          ),
        );
      }
    );
  }
}