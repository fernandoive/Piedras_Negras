class ColoniaModel {
  final int id;
  final String municipio;
  final int seccion;
  final String colonia;
  final String calle;
  final String createAt;

  ColoniaModel({
    required this.id,
    required this.municipio,
    required this.seccion,
    required this.colonia,
    required this.calle,
    required this.createAt,
  });

  factory ColoniaModel.fromJson(Map<String, dynamic> json) {
    return ColoniaModel(
      id: json['id'] as int,
      municipio: json['municipio'] as String,
      seccion: json['seccion'] as int,
      colonia: json['colonia'] as String,
      calle: json['calle'] as String,
      createAt: json['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'municipio': municipio,
        'seccion': seccion,
        'colonia': colonia,
        'calle': calle,
        'createAt': createAt,
      };

        @override
  String toString() {
    return 'Seccion(id: $id, municipio: $municipio, seccion: $seccion, colonia: $colonia, createAt: $createAt)';
  }
}
