class DataCalls {
    bool ok;
    int total;
    List<Registros> registros;

    DataCalls({
        required this.ok,
        required this.total,
        required this.registros,
    });

    factory DataCalls.fromJson(Map<String, dynamic> json) => DataCalls(
        ok: json["OK"],
        total: json["total"],
        registros: List<Registros>.from(json["registros"].map((x) => Registros.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "OK": ok,
        "total": total,
        "registros": List<dynamic>.from(registros.map((x) => x.toJson())),
    };
}

class Registros {
    String id;
    String uid;
    String distrito;
    String seccion;
    String nombre;
    String apellidoP;
    String apellidoM;
    String municipio;
    String telefono;
    dynamic duracion;
    String observaciones;
    String versionapp;
    DateTime createAt;
    dynamic updateAt;
    String verificado;

    Registros({
        required this.id,
        this.uid = '',
        required this.distrito,
        required this.seccion,
        required this.nombre,
        required this.apellidoP,
        required this.apellidoM,
        required this.municipio,
        required this.telefono,
        required this.duracion,
        required this.observaciones,
        required this.versionapp,
        required this.createAt,
        required this.updateAt,
        required this.verificado,
    });

    factory Registros.fromJson(Map<String, dynamic> json) => Registros(
        id: json["id"].toString(),
        distrito: json["distrito"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        municipio: json["municipio"],
        seccion: json["seccion"].toString(),
        telefono: json["telefono"].toString(),
        verificado: json["verificado"],
        observaciones: json["observaciones"],
        versionapp: json["versionapp"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: json["updateAt"].toString(), 
        duracion: json["duracion"],
    );

    factory Registros.fromJsonDB(Map<String, dynamic> json) => Registros(
        id: json["id"].toString(),
        uid: json["uid"],
        distrito: json["distrito"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        municipio: json["municipio"],
        seccion: json["seccion"].toString(),
        telefono: json["telefono"].toString(),
        verificado: json["verificado"],
        observaciones: json["observaciones"],
        versionapp: json["versionapp"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: json["updateAt"], 
        duracion: json["duracion"],
    );

      Map<String, dynamic> toJson() => {
        "id": id,
        "distrito": distrito,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "municipio": municipio,
        "seccion": seccion,
        "telefono": telefono,
        "verificado": verificado,
        "observaciones": observaciones,
        "versionapp": versionapp,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt,
        "duracion": duracion,
    };

      Map<String, dynamic> toJsonDB() => {
        "uid": id,
        "distrito": distrito,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "municipio": municipio,
        "seccion": seccion,
        "telefono": telefono,
        "verificado": verificado,
        "observaciones": observaciones,
        "versionapp": versionapp,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt,
        "duracion": duracion,
    };

}