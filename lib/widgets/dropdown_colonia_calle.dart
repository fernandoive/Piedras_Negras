import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropDownColoniaWidget extends StatefulWidget {
  final bool isCalle;
  final List<String> listItems;
  final String label;
  final HomeBloc homeBloc;
  const DropDownColoniaWidget({
    super.key,
    required this.isCalle,
    required this.listItems,
    required this.label, required this.homeBloc,
  });

  @override
  State<DropDownColoniaWidget> createState() => _DropDownColoniaWidgetState();
}

class _DropDownColoniaWidgetState extends State<DropDownColoniaWidget> {

  String valueSel = '';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width:  double.infinity,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: DropdownSearch<String>(
        items: widget.listItems,
        clearButtonProps: ClearButtonProps(
          icon: Icon(Icons.clear)
        ),
        selectedItem: valueSel,
        validator: (v) => v == null ? "Campo requerido" : null,
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
            color: Colors.white
          ),
            dropdownSearchDecoration: InputDecoration(
              suffixIconColor: Colors.white,
              labelText: widget.label,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              disabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.white,
              ),
              errorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              ),
            ),
        onChanged: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(widget.isCalle) {
            await prefs.setString('calleSel', value!);
            widget.homeBloc.calleSelectedNext(value);
          } else {
            await prefs.setString('coloniaSel', value!);
            widget.homeBloc.coloniaSelectedNext(value);
          }
          valueSel = value!;
          setState(() {});
        },
      ),
    );
  }
}