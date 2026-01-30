import 'dart:io';
import 'package:data_analitica_2/models/ciudadano_model.dart';
import 'package:data_analitica_2/models/data_call_model.dart';
import 'package:data_analitica_2/models/data_user_model.dart';
import 'package:data_analitica_2/models/formulario_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseProvider{

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, "jr.db");
    return await openDatabase(path, version: 4, onOpen: (db) {},
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE encuesta ADD COLUMN duracion VARCHAR'
          );
        }
      },
      onCreate: (Database db, int version) async {
      await db.execute(
        '''CREATE TABLE calls (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uid VARCHAR,
              distrito VARCHAR,
              nombre VARCHAR,
              apellidoP VARCHAR,
              apellidoM VARCHAR,
              duracion VARCHAR,
              seccion VARCHAR,
              telefono VARCHAR,
              observaciones VARCHAR,
              versionapp VARCHAR,
              verificado VARCHAR,
              createAt VARCHAR,
              updateAt VARCHAR,
              municipio VARCHAR
        )'''
      );
      await db.execute(
        '''CREATE TABLE encuesta (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            createAt VARCHAR,
            latitud VARCHAR,
            longitud VARCHAR,
            uidUser VARCHAR,
            pregunta1 VARCHAR,
            pregunta2 VARCHAR,
            pregunta3 VARCHAR,
            pregunta4 VARCHAR,
            pregunta5 VARCHAR,
            pregunta6 VARCHAR, 
            pregunta7 VARCHAR,
            pregunta8 VARCHAR, 
            pregunta9 VARCHAR,
            pregunta10 VARCHAR,
            pregunta11 VARCHAR,
            nombre VARCHAR,
            apellidoP VARCHAR, 
            apellidoM VARCHAR, 
            telefono VARCHAR,
            colonia VARCHAR,
            seccion VARCHAR,
            zona VARCHAR,
            calle VARCHAR,
            numero VARCHAR, 
            versionapp VARCHAR, 
            email VARCHAR, 
            urlAudio VARCHAR,
            duracion VARCHAR)'''
      );
      await db.execute(
        "CREATE TABLE coordenadas (id INTEGER PRIMARY KEY AUTOINCREMENT, createAt VARCHAR, municipio VARCHAR, latitud VARCHAR, longitud VARCHAR uidUser VARCHAR, distrito VARCHAR)"
      );
      await db.execute(
        '''CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uid VARCHAR,
              distrito VARCHAR,
              folioid VARCHAR,
              rol VARCHAR,
              nombre VARCHAR,
              apellidoP VARCHAR,
              apellidoM VARCHAR,
              municipio VARCHAR,
              seccion VARCHAR,
              colonia VARCHAR,
              calle VARCHAR,
              numExt VARCHAR,
              numInt VARCHAR,
              cp VARCHAR,
              telefono VARCHAR,
              comite VARCHAR,
              dv VARCHAR,
              mov VARCHAR,
              cuantos VARCHAR,
              verificado VARCHAR,
              latitud VARCHAR,
              longitud VARCHAR,
              observaciones VARCHAR,
              amigosVoluntarios VARCHAR,
              encuestado VARCHAR,
              encuestador VARCHAR,
              versionapp VARCHAR,
              urlAudio VARCHAR,
              createAt VARCHAR,
              updateAt VARCHAR
        )'''
      );
      await db.execute(
        '''CREATE TABLE verificados (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              uid VARCHAR,
              distrito VARCHAR,
              folioid VARCHAR,
              rol VARCHAR,
              nombre VARCHAR,
              apellidoP VARCHAR,
              apellidoM VARCHAR,
              municipio VARCHAR,
              seccion VARCHAR,
              colonia VARCHAR,
              calle VARCHAR,
              numExt VARCHAR,
              numInt VARCHAR,
              cp VARCHAR,
              telefono VARCHAR,
              comite VARCHAR,
              dv VARCHAR,
              mov VARCHAR,
              cuantos VARCHAR,
              verificado VARCHAR,
              latitud VARCHAR,
              longitud VARCHAR,
              observaciones VARCHAR,
              amigosVoluntarios VARCHAR,
              encuestado VARCHAR,
              encuestador VARCHAR,
              versionapp VARCHAR,
              urlAudio VARCHAR,
              createAt VARCHAR,
              updateAt VARCHAR
        )'''
      );
      await db.execute(
        '''CREATE TABLE ciudadano (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              rol VARCHAR,
              nombre VARCHAR,
              apellidoP VARCHAR,
              apellidoM VARCHAR,
              distrito VARCHAR,
              municipio VARCHAR,
              seccion VARCHAR,
              colonia VARCHAR,
              calle VARCHAR,
              num_ext VARCHAR,
              num_int VARCHAR,
              cp VARCHAR,
              telefono VARCHAR,
              dv VARCHAR,
              mov VARCHAR,
              comite VARCHAR,
              cuantos VARCHAR,
              latitud VARCHAR,
              longitud VARCHAR,
              observaciones VARCHAR,
              amigos_voluntarios VARCHAR,
              encuestador VARCHAR,
              versionapp VARCHAR,
              urlAudio VARCHAR
        )'''
      );
    });
  }

  Future<int> registroEncuesta(Formulario newFormulario) async {
    var db = await database;
    int res = await db.insert("encuesta", newFormulario.toMap());
    return res;
  }

  Future<int> registroCiudadano(Map<String, dynamic> newFormulario) async {
    var db = await database;
    int res = await db.insert("ciudadano", newFormulario);
    return res;
  }

  Future<int> registroUsers(DataUser newFormulario) async {
    var db = await database;
    int res = await db.insert("users", newFormulario.toJsonDB());
    return res;
  }

  Future<int> registroCalls(Registros newFormulario) async {
    var db = await database;
    int res = await db.insert("calls", newFormulario.toJsonDB());
    return res;
  }

  Future<int> registroVerificados(DataUser newFormulario) async {
    var db = await database;
    int res = await db.insert("verificados", newFormulario.toJsonDB());
    return res;
  }

  Future<int> obtenerEncuestasConteo() async {
    var db = await database;
    int? count;
    count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM verificados'));
    if(count == null) {
      count = 0;
    }
    return count;
  }

  Future<int> obtenerEncuestasCount() async {
    var db = await database;
    int count = 0;
    count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM encuesta'))!;
    return count;
  }

  Future<int> obtenerCiudadanoConteo() async {
    var db = await database;
    int? count;
    count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ciudadano'));
    if(count == null) {
      count = 0;
    }
    return count;
  }

  Future<List<CiudadanoModel>>getCiudadano() async {
    final db = await database;
    var res = await db.query("ciudadano");
    return res.isNotEmpty ?
        res.map((c) => CiudadanoModel.fromData(c)).toList() : [];
  }
  
  Future<List<DataUser>>getVerificados() async {
    final db = await database;
    var res = await db.query("verificados");
    return res.isNotEmpty ?
        res.map((c) => DataUser.fromJsonDB(c)).toList() : [];
  }

  Future<List<Formulario>>getEncuestados() async {
    final db = await database;
    var res = await db.query("encuesta");
    return res.isNotEmpty ?
        res.map((c) => Formulario.fromMap(c)).toList() : [];
  }

  Future<List<DataUser>>getUsers(
    Function(bool) nextSave
  ) async {
    final db = await database;
    var res = await db.query("users");
    nextSave(true);
    return res.isNotEmpty ?
        res.map((c) => DataUser.fromJsonDB(c)).toList() : [];
  }

  Future<List<Registros>>getCalls(
    Function(bool) nextSave
  ) async {
    final db = await database;
    var res = await db.query("calls");
    nextSave(true);
    return res.isNotEmpty ?
        res.map((c) => Registros.fromJsonDB(c)).toList() : [];
  }

  Future<List<DataUser>>getCountUsers() async {
    final db = await database;
    var res = await db.query("users");
    return res.isNotEmpty ?
        res.map((c) => DataUser.fromJsonDB(c)).toList() : [];
  }

  Future<List<DataUser>>getCountCalls() async {
    final db = await database;
    var res = await db.query("calls");
    return res.isNotEmpty ?
        res.map((c) => DataUser.fromJsonDB(c)).toList() : [];
  }

  Future deleteEncuesta(int id) async {
    final db = await database;
    return db.delete("verificados", where: "id = ?", whereArgs: [id]);
  }

  Future deleteEnc(int id) async {
    final db = await database;
    return db.delete("encuesta", where: "id = ?", whereArgs: [id]);
  }

  Future deleteCall(int id) async {
    final db = await database;
    return db.delete("calls", where: "id = ?", whereArgs: [id]);
  }
  
  Future deleteCiudadano(int id) async {
    final db = await database;
    return db.delete("ciudadano", where: "id = ?", whereArgs: [id]);
  }

  Future deleteUsers() async {
    final db = await database;
    return db.delete('users');
  }

  Future deleteCalls() async {
    final db = await database;
    return db.delete('calls');
  }


}