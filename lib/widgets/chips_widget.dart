import 'dart:convert';

import 'package:data_analitica_2/models/seccion_model.dart';
import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:data_analitica_2/services/encuesta/encuesta_service.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChipsWidget extends StatefulWidget {
  final List<String> secciones;
  final List<String> activas;
  final Function(String) next;
  final Function(SeccionModel) next2;
  final Function(bool) nextSave;
  final Function(bool) activeSave;
  final Stream<String> stream;
  final String? value; 
  final HomeBloc homeBloc;
  final bool isJZ;

  const ChipsWidget({super.key, required this.secciones, required this.activas, required this.next, required this.next2, required this.nextSave, required this.activeSave, this.value, required this.stream, required this.homeBloc, required this.isJZ});

  @override
  State<ChipsWidget> createState() => _ChipsWidgetState();
}

class _ChipsWidgetState extends State<ChipsWidget> {

  List<String> activas = [];
  
  Future<void> getColonias(String seccion) async {
    try{
      bool result = await InternetConnection().hasInternetAccess;
      if(result) { 
        widget.homeBloc.mostrarCircularProgressNext(true);
        await EncuestaServices.instance.getCercaSeccionalActiva(seccion: seccion);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        SeccionModel seccionModel = SeccionModel.fromData(jsonDecode(prefs.getString('sesion')!));

        if(seccionModel.fin.isNotEmpty) {
          widget.next2(seccionModel);
          widget.nextSave(true);
          widget.activeSave(true);
          await EncuestaServices.instance.getColonias(seccion: seccion);
          final jsonString = prefs.getString('seccionesActivas');
          if (jsonString != null) {
            final List decoded = jsonDecode(jsonString);
            final res = decoded.map((e) => SeccionModel.fromData(e)).toList();
            widget.homeBloc.seccionesActivasNext(res);
            for(int i = 0; i < res.length; i++) {
              activas.add(res[i].seccion);
            }
            setState(() {});
          }
        } else {
          widget.next2(SeccionModel());
          widget.nextSave(false);
          widget.activeSave(false);
        }

        var colonias = prefs.getStringList('colonias') ?? [];
        var calles = prefs.getStringList('calles') ?? [];

        widget.homeBloc.coloniaSelectedNext('');
        widget.homeBloc.calleSelectedNext('');
        widget.homeBloc.coloniasNext(colonias.toSet().toList());
        widget.homeBloc.callesNext(calles.toSet().toList());

        widget.homeBloc.mostrarCircularProgressNext(false);
      }
    } catch (e) {
      widget.homeBloc.mostrarCircularProgressNext(false);
      widget.activeSave(false);
    }
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
   return StreamBuilder(
      stream: widget.homeBloc.seccionesActivas,
      builder: (context, listdata) {
        List<SeccionModel> data = [];
        if(listdata.hasData) {
          data = listdata.data!;
        }
       return StreamBuilder<String>(
          stream: widget.stream,
          builder: (context, snapshot) {
            String value = '';
            if(snapshot.hasData) {
              value = snapshot.data!;
            }
            return Wrap(
              spacing: 8,
              children: widget.secciones.map((seccion) {
                final isSelected = activas.isNotEmpty ? activas.contains(seccion) : widget.activas.contains(seccion);
                return FilterChip(
                  label: Text(seccion),
                  backgroundColor: Colors.grey,
                  checkmarkColor: value == seccion ? Colors.white : Color.fromARGB(249, 192, 126, 131),
                  selectedColor:  value == seccion ? Color(0xffbaf272f) : Color.fromARGB(249, 192, 126, 131),
                  labelStyle: TextStyle(color: Colors.white),
                  selected: data.isNotEmpty ? isSelected : value == seccion,
                  onSelected: (value) async {
                    if(widget.isJZ) {
                      if(isSelected) {
                        widget.homeBloc.coloniasNext([]);
                        widget.homeBloc.callesNext([]);
                        widget.homeBloc.coloniaSelectedNext('');
                        widget.homeBloc.calleSelectedNext('');
                        widget.next(seccion);
                        widget.nextSave(false);
                        await getColonias(seccion);
                      }
                    }
                  },
                );
              }).toList(),
            );
          }
        );
     }
   );
  }
}
