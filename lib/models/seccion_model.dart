class SeccionModel {
  final int id;
  final String municipio;
  final String seccion;
  final String zona;
  final String inicio;
  final String fin;

  SeccionModel({
    this.id = 0,
    this.municipio = '',
    this.seccion = '',
    this.zona = '',
    this.inicio = '',
    this.fin = '',
  });

  factory SeccionModel.fromJson(Map<String, dynamic> json) {
    return SeccionModel(
      id: json['id'] as int,
      municipio: json['municipio'] as String,
      seccion: json['seccion'] as String,
      zona: json['zona'] as String,
      inicio: json['fecha_inicio'],
      fin: json['fecha_fin'],
    );
  }

  factory SeccionModel.fromData(Map<String, dynamic> json) {
    return SeccionModel(
      id: json['id'] as int,
      municipio: json['municipio'] as String,
      seccion: json['seccion'] as String,
      zona: json['zona'] as String,
      inicio: json['inicio'],
      fin: json['fin'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'municipio': municipio,
        'seccion': seccion,
        'zona': zona,
        'inicio': inicio,
        'fin': fin,
      };

        @override
  String toString() {
    return 'Seccion(id: $id, municipio: $municipio, seccion: $seccion, zona: $zona, inicio: $inicio)';
  }
}
