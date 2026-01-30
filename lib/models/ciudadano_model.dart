class CiudadanoModel {
  int id;
  String rol;
  String nombre;
  String apellidoP;
  String apellidoM;
  String distrito;
  String municipio;
  String seccion;
  String colonia;
  String calle;
  String num_ext;
  String num_int;
  String cp;
  String telefono;
  String dv;
  String mov;
  String comite;
  String cuantos;
  String latitud;
  String longitud;
  String observaciones;
  String amigos_voluntarios;
  String encuestador;
  String versionapp;
  String urlAudio;

  CiudadanoModel({
    this.id = 0,
    this.rol = '',
    this.nombre = '',
    this.apellidoP = '',
    this.apellidoM = '',
    this.distrito = '',
    this.municipio = '',
    this.seccion = '',
    this.colonia = '',
    this.calle = '',
    this.num_ext = '',
    this.num_int = '',
    this.cp = '',
    this.telefono = '',
    this.dv = '',
    this.mov = '',
    this.comite = '',
    this.cuantos = '',
    this.latitud = '',
    this.longitud = '',
    this.observaciones = '',
    this.amigos_voluntarios = '',
    this.encuestador = '',
    this.versionapp = '',
    this.urlAudio = '',
  });

    factory CiudadanoModel.fromData(Map<String, dynamic> snapshot) {
    return CiudadanoModel(
      id: snapshot['id'],
      rol: snapshot['rol'],
      nombre: snapshot['nombre'],
      apellidoP: snapshot['apellidoP'],
      apellidoM: snapshot['apellidoM'],
      distrito: snapshot['distrito'],
      municipio: snapshot['municipio'],
      seccion: snapshot['seccion'],
      colonia: snapshot['colonia'],
      calle: snapshot['calle'],
      num_ext: snapshot['num_ext'],
      num_int: snapshot['num_int'],
      cp: snapshot['cp'],
      telefono: snapshot['telefono'],
      dv: snapshot['dv'],
      mov: snapshot['mov'],
      comite: snapshot['comite'],
      cuantos: snapshot['cuantos'],
      latitud: snapshot['latitud'],
      longitud: snapshot['longitud'],
      observaciones: snapshot['observaciones'],
      amigos_voluntarios: snapshot['amigos_voluntarios'],
      encuestador: snapshot['encuestador'],
      versionapp: snapshot['versionapp'],
      urlAudio: snapshot['urlAudio'],
    );
  }

  Map<String, dynamic> toJson() => {
    "rol": rol,
    "nombre": nombre,
    "apellidoP": apellidoP,
    "apellidoM": apellidoM,
    "distrito": distrito,
    "municipio": municipio,
    "seccion": seccion,
    "colonia": colonia,
    "calle": calle,
    "num_ext": num_ext,
    "num_int": num_int,
    "cp": cp,
    "telefono": telefono,
    "dv": dv,
    "mov": mov,
    "comite": comite,
    "cuantos": cuantos,
    "latitud": latitud,
    "longitud": longitud,
    "observaciones": observaciones,
    "amigos_voluntarios": amigos_voluntarios,
    "encuestador": encuestador,
    "versionapp": versionapp,
    "urlAudio": urlAudio,
  };

}