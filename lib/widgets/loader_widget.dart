import 'package:data_analitica_2/util/constantes.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
    required this.streamMostrarCircularProgress,
    required this.child,
  });

  final Stream<bool> streamMostrarCircularProgress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamMostrarCircularProgress,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool mostrarCircularProgress = snapshot.data!;

          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                  ignoring: (mostrarCircularProgress) ? true : false,
                  child: Opacity(
                    opacity: (mostrarCircularProgress) ? 0.5 : 1.0,
                    child: child,
                  ),
                ),
              ),
              (mostrarCircularProgress)
              ? Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: primaryColor, 
                        size: 50
                      )
                    ),
                  ))
              : Container()
        ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}