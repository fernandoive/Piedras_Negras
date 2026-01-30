class GPSModel{
  String? createAt;
  double? latitud;
  double? longitud;
  String? uidUser;
  String? uUser;
  String? unameUser;
  String? utypeUser;

  GPSModel({
    this.createAt = '',
    this.latitud = 0,
    this.longitud = 0,
    this.uidUser = '',
    this.uUser = '',
    this.unameUser = '',
    this.utypeUser = '',
  });
  
  Map<String, dynamic> toMap() => {
    "createAt": createAt,
    "latitud": latitud.toString(),
    "longitud": longitud.toString(),
    "uidUser": uidUser,
  };

  Map<String, dynamic> toMapCoordenada() => {
    "latitud": latitud.toString(),
    "longitud": longitud.toString(),
    "usuario": utypeUser,
    "nombre": unameUser
  };
}