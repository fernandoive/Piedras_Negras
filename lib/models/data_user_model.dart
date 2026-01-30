class Users {
    bool ok;
    int total;
    List<DataUser> ciudadanos;

    Users({
        required this.ok,
        required this.total,
        required this.ciudadanos,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        ok: json["OK"],
        total: json["total"],
        ciudadanos: List<DataUser>.from(json["ciudadanos"].map((x) => DataUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "OK": ok,
        "total": total,
        "ciudadanos": List<dynamic>.from(ciudadanos.map((x) => x.toJson())),
    };
}

class DataUser {
    String id;
    String uid;
    String distrito;
    String folioid;
    String rol;
    String nombre;
    String apellidoP;
    String apellidoM;
    String municipio;
    String seccion;
    String colonia;
    String calle;
    String numExt;
    String numInt;
    String cp;
    String telefono;
    String comite;
    String dv;
    String mov;
    String cuantos;
    String verificado;
    dynamic latitud;
    dynamic longitud;
    String observaciones;
    String amigosVoluntarios;
    String encuestado;
    String encuestador;
    String versionapp;
    dynamic urlAudio;
    DateTime createAt;
    dynamic updateAt;

    DataUser({
        required this.id,
        this.uid = '',
        required this.distrito,
        required this.folioid,
        required this.rol,
        required this.nombre,
        required this.apellidoP,
        required this.apellidoM,
        required this.municipio,
        required this.seccion,
        required this.colonia,
        required this.calle,
        required this.numExt,
        required this.numInt,
        required this.cp,
        required this.telefono,
        required this.comite,
        required this.dv,
        required this.mov,
        required this.cuantos,
        required this.verificado,
        required this.latitud,
        required this.longitud,
        required this.observaciones,
        required this.amigosVoluntarios,
        required this.encuestado,
        required this.encuestador,
        required this.versionapp,
        required this.urlAudio,
        required this.createAt,
        required this.updateAt,
    });

    factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json["id"].toString(),
        distrito: json["distrito"],
        folioid: json["folioid"],
        rol: json["rol"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        municipio: json["municipio"],
        seccion: json["seccion"].toString(),
        colonia: json["colonia"],
        calle: json["calle"],
        numExt: json["num_ext"].toString(),
        numInt: json["num_int"].toString(),
        cp: json["cp"].toString(),
        telefono: json["telefono"].toString(),
        comite: json["comite"],
        dv: json["DV"],
        mov: json["MOV"],
        cuantos: json["cuantos"].toString(),
        verificado: json["verificado"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        observaciones: json["observaciones"],
        amigosVoluntarios: json["amigos_voluntarios"],
        encuestado: json["encuestado"].toString(),
        encuestador: json["encuestador"],
        versionapp: json["versionapp"],
        urlAudio: json["urlAudio"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: json["updateAt"],
    );

    factory DataUser.fromJsonDB(Map<String, dynamic> json) => DataUser(
        id: json["id"].toString(),
        uid: json["uid"],
        distrito: json["distrito"],
        folioid: json["folioid"],
        rol: json["rol"],
        nombre: json["nombre"],
        apellidoP: json["apellidoP"],
        apellidoM: json["apellidoM"],
        municipio: json["municipio"],
        seccion: json["seccion"],
        colonia: json["colonia"],
        calle: json["calle"],
        numExt: json["numExt"].toString(),
        numInt: json["numInt"].toString(),
        cp: json["cp"].toString(),
        telefono: json["telefono"],
        comite: json["comite"],
        dv: json["dv"].toString(),
        mov: json["mov"].toString(),
        cuantos: json["cuantos"],
        verificado: json["verificado"],
        latitud: json["latitud"].toString(),
        longitud: json["longitud"].toString(),
        observaciones: json["observaciones"].toString(),
        amigosVoluntarios: json["amigosVoluntarios"],
        encuestado: json["encuestado"],
        encuestador: json["encuestador"],
        versionapp: json["versionapp"],
        urlAudio: json["urlAudio"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: json["updateAt"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "distrito": distrito,
        "folioid": folioid,
        "rol": rol,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "municipio": municipio,
        "seccion": seccion,
        "colonia": colonia,
        "calle": calle,
        "num_ext": numExt,
        "num_int": numInt,
        "cp": cp,
        "telefono": telefono,
        "comite": comite,
        "DV": dv,
        "MOV": mov,
        "cuantos": cuantos,
        "verificado": verificado,
        "latitud": latitud,
        "longitud": longitud,
        "observaciones": observaciones,
        "amigos_voluntarios": amigosVoluntarios,
        "encuestado": encuestado,
        "encuestador": encuestador,
        "versionapp": versionapp,
        "urlAudio": urlAudio,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt,
    };

    Map<String, dynamic> toJsonDB() => {
        "uid": id,
        "distrito": distrito,
        "folioid": folioid,
        "rol": rol,
        "nombre": nombre,
        "apellidoP": apellidoP,
        "apellidoM": apellidoM,
        "municipio": municipio,
        "seccion": seccion,
        "colonia": colonia,
        "calle": calle,
        "numExt": numExt,
        "numInt": numInt,
        "cp": cp,
        "telefono": telefono,
        "comite": comite,
        "dv": dv,
        "mov": mov,
        "cuantos": cuantos,
        "verificado": verificado,
        "latitud": latitud,
        "longitud": longitud,
        "observaciones": observaciones,
        "amigosVoluntarios": amigosVoluntarios,
        "encuestado": encuestado,
        "encuestador": encuestador,
        "versionapp": versionapp,
        "urlAudio": urlAudio,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt,
    };
}
