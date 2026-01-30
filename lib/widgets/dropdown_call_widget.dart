import 'package:data_analitica_2/services/database/database.dart';
import 'package:data_analitica_2/services/gps/gps_service.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:data_analitica_2/widgets/snackbar_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DropDownCallWidget extends StatefulWidget {
  final Function(String) next;
  final Function(bool) nextSave;
  final String? value;
  final Stream<String> stream;
  final List<String>? listItems;
  final double? width;
  final String? label;
  final VoidCallback? onChanged;
  const DropDownCallWidget({
    super.key,
    required this.next,
    required this.nextSave,
    required this.value,
    required this.stream,
    this.listItems,
    this.width,
    this.label,
    this.onChanged,
  });

  @override
  State<DropDownCallWidget> createState() => _DropDownCallWidgetState();
}

class _DropDownCallWidgetState extends State<DropDownCallWidget> {
  
  Future<void> getListUsers(String seccion) async {
    try{
      bool result = await InternetConnection().hasInternetAccess;
      if(result) {
        await GPSServices.instance.getCalls(seccion: seccion);
        var res = await DatabaseProvider.db.getCountCalls();
        if(res.isEmpty) {
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBarWidget.instance.snackBarWarning(message: 'Esta seccion no tiene usuarios'));
        }
        widget.nextSave(true);
      }
    } catch (e) {}
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
              widget.next(value!);
              widget.nextSave(false);
              await getListUsers(value);
            },
          ),
        );
      }
    );
  }
}