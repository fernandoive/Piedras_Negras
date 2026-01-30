class Formulario{
  String? id;
  String? createAt;
  double? latitud;
  double? longitud;
  String? a;
  String? b;
  String? c;
  String? d;
  String? e;
  String? f;
  String? g;
  String? h;
  String? i;
  String? j;
  String? k;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? telefono;
  String? versionapp;
  String? uidUser;
  String? email;
  String? urlAudio;
  String? colonia;
  String? calle;
  String? numero;
  String? seccion;
  String? zona;
  String? duracion;

  Formulario({
    this.id,
    this.createAt,
    this.latitud,
    this.longitud,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.i,
    this.j,
    this.k,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.telefono,
    this.versionapp,
    this.uidUser,
    this.email,
    this.urlAudio,
    this.colonia,
    this.calle,
    this.numero,
    this.seccion,
    this.zona,
    this.duracion,
  });

  @override
  String toString() {
    return 'Formulario { id: $id, createAt: $createAt, latitud: $latitud, longitud: $longitud, a: $a, b: $b, c: $c, d: $d, e: $e, f: $f, g: $g, h: $h, i: $i, j: $j, k: $k, uidUser: $uidUser, nombre: $nombre, apellidoP: $apellidoPaterno, apellidoM: $apellidoMaterno, telefono: $telefono, versionapp: $versionapp, f: $f, duracion: $duracion }';
  }

  factory Formulario.fromMap(Map<String, dynamic> json) => new Formulario(
    id: json["id"].toString(),
    createAt: json["createAt"],
    latitud: double.parse(json["latitud"]),
    longitud: double.parse(json["longitud"]),
    a: json["pregunta1"],
    b: json["pregunta2"],
    c: json["pregunta3"],
    d: json["pregunta4"],
    e: json["pregunta5"],
    f: json["pregunta6"],
    g: json["pregunta7"],
    h: json["pregunta8"],
    i: json["pregunta9"],
    j: json["pregunta10"],
    k: json["pregunta11"],
    nombre: json["nombre"],
    apellidoPaterno: json["apellidoP"],
    apellidoMaterno: json["apellidoM"],
    telefono: json["telefono"],
    versionapp: json["versionapp"],
    uidUser: json["uidUser"],
    email: json["email"],
    urlAudio: json["urlAudio"],
    colonia: json["colonia"],
    calle: json["calle"],
    numero: json["numero"],
    seccion: json["seccion"],
    zona: json["zona"],
    duracion: json["duracion"] ?? "00:00:00"
  );

    Map<String, dynamic> toMap() => {
      "createAt": createAt,
      "latitud": latitud.toString(),
      "longitud": longitud.toString(),
      "pregunta1": a,
      "pregunta2": b,
      "pregunta3": c,
      "pregunta4": d,
      "pregunta5": e,
      "pregunta6": f,
      "pregunta7": g,
      "pregunta8": h,
      "pregunta9": i,
      "pregunta10": j,
      "pregunta11": k,
      "nombre": nombre,
      "apellidoP": apellidoPaterno,
      "apellidoM": apellidoMaterno,
      "telefono": telefono,
      "versionapp": versionapp,
      "uidUser": uidUser,
      "email": email,
      "urlAudio": urlAudio,
      "colonia": colonia,
      "calle": calle,
      "numero": numero,
      "seccion": seccion,
      "zona": zona,
      "duracion": duracion
    };

    Map<String, dynamic> toSend() => {
      "createAt": createAt,
      "latitud": latitud.toString(),
      "longitud": longitud.toString(),
      "pregunta1": a,
      "pregunta2": b,
      "pregunta3": c,
      "pregunta4": d,
      "pregunta5": e,
      "pregunta6": f,
      "pregunta7": g,
      "pregunta8": h,
      "pregunta9": i,
      "pregunta10": j,
      "pregunta11": k,
      "nombre": nombre,
      "apellidoP": apellidoPaterno,
      "apellidoM": apellidoMaterno,
      "telefono": telefono,
      "versionapp": versionapp,
      "usuario": email,
      "urlAudio": urlAudio,
      "colonia": colonia,
      "calle": calle,
      "num_ext": numero,
      "seccion": seccion,
      "zona": zona,
      "duracion": duracion
    };
}