import 'dart:convert';
import 'package:data_analitica_2/models/seccion_model.dart';
import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:data_analitica_2/services/encuesta/encuesta_service.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropDownWidget extends StatefulWidget {
  final Function(String) next;
  final Function(SeccionModel) next2;
  final Function(bool) nextSave;
  final Function(bool) activeSave;
  final String? value;
  final Stream<String> stream;
  final List<String>? listItems;
  final double? width;
  final String? label;
  final VoidCallback? onChanged;
  final bool? isCalle;
  final HomeBloc homeBloc;
  const DropDownWidget({
    super.key,
    required this.next,
    required this.next2,
    required this.nextSave,
    required this.activeSave,
    required this.value,
    required this.stream,
    this.listItems,
    this.width,
    this.label,
    this.onChanged,
    this.isCalle, required this.homeBloc,
  });

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  
  Future<void> getColonias(String seccion) async {
    try{
      bool result = await InternetConnection().hasInternetAccess;
      if(result) { 
        await EncuestaServices.instance.getCercaSeccionalActiva(seccion: seccion);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        SeccionModel seccionModel = SeccionModel.fromData(jsonDecode(prefs.getString('sesion')!));

        if(seccionModel.fin.isNotEmpty) {
          widget.next2(seccionModel);
          widget.nextSave(true);
          widget.activeSave(true);
          await EncuestaServices.instance.getColonias(seccion: seccion);
        } else {
          widget.next2(SeccionModel());
          widget.nextSave(false);
          widget.activeSave(false);
        }

        var colonias = prefs.getStringList('colonias') ?? [];
        var calles = prefs.getStringList('calles') ?? [];

        if(colonias.isEmpty) {
          widget.homeBloc.coloniasNext([]);
          widget.homeBloc.callesNext([]);
          widget.homeBloc.coloniaSelectedNext('');
          widget.homeBloc.calleSelectedNext('');
        } else {
          widget.homeBloc.coloniasNext(colonias.toSet().toList());
          widget.homeBloc.callesNext(calles.toSet().toList());
        }

      }
    } catch (e) {
      widget.activeSave(false);
    }
      setState(() {});
  }

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
              baseStyle: TextStyle(
                color: Colors.white
              ),
                dropdownSearchDecoration: InputDecoration(
                  suffixIconColor: Colors.white,
                  labelText: widget.label ?? "",
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
              widget.homeBloc.coloniasNext([]);
              widget.homeBloc.callesNext([]);
              widget.homeBloc.coloniaSelectedNext('');
              widget.homeBloc.calleSelectedNext('');
              widget.next(value!);
              widget.nextSave(false);
              await getColonias(value.trim());
            },
          ),
        );
      }
    );
  }
}