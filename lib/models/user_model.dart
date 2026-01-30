class UserModel {
  int id;
  String nombre;
  String apellidoP;
  String apellidoM;
  String correo;
  String rol;
  String zona;
  String secciones;
  String password;

  UserModel(
    {
    this.id = 0,
    this.nombre = '',
    this.apellidoP = '',
    this.apellidoM = '',
    this.correo = '',
    this.rol = '',
    this.zona = '',
    this.secciones = '',
    this.password = ''
    }
  );

  factory UserModel.fromData(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellidoP: json['apellidoP'] as String,
      apellidoM: json['apellidoM'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
      zona: json['zona'] as String,
      secciones: json['secciones'] as String,
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellidoP': apellidoP,
    'apellidoM': apellidoM,
    'correo': correo,
    'rol': rol,
    'zona': zona,
    'secciones': secciones,
    'password': password,
  };

  factory UserModel.fromJson(Map<String, dynamic> json, String pass) {
    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellidoP: json['apellidoP'] as String,
      apellidoM: json['apellidoM'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
      zona: json['zona'] as String,
      secciones: json['secciones'] as String,
      password: pass
    );
  }
}