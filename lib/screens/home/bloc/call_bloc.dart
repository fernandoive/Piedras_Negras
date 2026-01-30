import 'package:data_analitica_2/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class CallBloc {

  final _mostrarCircularProgress = BehaviorSubject<bool>.seeded(false);
  final _button = BehaviorSubject<bool>.seeded(true);

  final _user = BehaviorSubject<UserModel>.seeded(UserModel());
  final _seccion = BehaviorSubject<String>();
  final _seccionSave = BehaviorSubject<bool>.seeded(false);
  
  //////////////////////////////////////////////////
  ///       seccion
  //////////////////////////////////////////////////
  Stream<String> get seccion => _seccion.stream;

  String? get seccionValue => _seccion.valueOrNull;

  seccionNext(String seccion) {
    _seccion.sink.add(seccion);
  }
 
  //////////////////////////////////////////////////
  ///       seccionSave
  //////////////////////////////////////////////////
  Stream<bool> get seccionSave => _seccionSave.stream;

  bool? get seccionSaveValue => _seccionSave.valueOrNull;

  seccionSaveNext(bool seccionSave) {
    _seccionSave.sink.add(seccionSave);
  }

  //////////////////////////////////////////////////
  ///       mostrarCircularProgress
  //////////////////////////////////////////////////
  Stream<bool> get mostrarCircularProgress => _mostrarCircularProgress.stream;

  bool get mostrarCircularProgressValue => _mostrarCircularProgress.value;

  mostrarCircularProgressNext(bool mostrarCircularProgress) {
    _mostrarCircularProgress.sink.add(mostrarCircularProgress);
  }

  //////////////////////////////////////////////////
  ///       button
  //////////////////////////////////////////////////
  Stream<bool> get button => _button.stream;

  bool get buttonValue => _button.value;

  buttonNext(bool button) {
    _button.sink.add(button);
  }

  //////////////////////////////////////////////////
  ///       user
  //////////////////////////////////////////////////
  Stream<UserModel> get user => _user.stream;

  UserModel get userValue => _user.value;

  userNext(UserModel user) {
    _user.sink.add(user);
  }

  dispose() {
    _mostrarCircularProgress.close();
    _user.close();
    _seccion.close();
    _seccionSave.close();
  }

}