import 'package:rxdart/rxdart.dart';

class CheckBloc {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  dispose() {
    _mostrarCircularProgress.close();
  }

}