import 'package:data_analitica_2/screens/home/bloc/home_bloc.dart';
import 'package:data_analitica_2/screens/home/checkin_screen.dart';
import 'package:data_analitica_2/screens/home/checkout_screen.dart';
import 'package:data_analitica_2/screens/login/login_screen.dart';
import 'package:data_analitica_2/util/constantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class DrawerWidget extends StatefulWidget {

  final HomeBloc homeBloc;

  const DrawerWidget({
    super.key,
    required SidebarXController controller,
    required this.homeBloc
  })  : controller = controller;
  
  final SidebarXController controller;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SidebarX(
        controller: widget.controller,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(color: Colors.black),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 233, 236, 255),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 20,
          ),
          selectedIconTheme: IconThemeData(
            color: primaryColor,
            size: 20,
          ),
        ),
        extendedTheme: SidebarXTheme(
          width: 200,
          selectedTextStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        footerDivider: divider,
        headerBuilder: (context, extended) {
          return Column(
            children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/user.png'),
                ),
              ),
              extended ? FittedBox(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Text(
                    widget.homeBloc.userValue.nombre,
                    style: TextStyle(
                      color: Colors.black
                    ),
                  ),
                ),
              ) : const SizedBox()
            ],
          );
        }, 
        items: [
          SidebarXItem(
            iconWidget: Image.asset('assets/entrada.png', width: 25,),
            label: 'Check-in',
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckinScreen()));
            }
          ),
          SidebarXItem(
            iconWidget: Image.asset('assets/salida.png', width: 25,),
            label: 'Check-out',
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckOutScreen()));
            }
          ),
          SidebarXItem(
            iconWidget: Image.asset('assets/sesion.png', width: 25,),
            label: 'Cerrar sesion',
            onTap: () async {
              widget.homeBloc.mostrarCircularProgressNext(true);
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.remove('user');
              preferences.remove('seccionesActivas');
              preferences.remove('sesion');
              preferences.remove('colonias');
              preferences.remove('calles');
              preferences.remove('calleSel');
              preferences.remove('coloniaSel');
              widget.homeBloc.mostrarCircularProgressNext(false);
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
            }
          )
        ],
      ),
    );
  }
}

