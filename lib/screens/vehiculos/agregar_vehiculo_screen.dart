class Vehiculo {
  int? id;
  String placa;
  String marca;
  String modelo;
  int anio;

  Vehiculo({
    this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
    };
  }

  factory Vehiculo.fromMap(Map<String, dynamic> map) {
    return Vehiculo(
      id: map['id'],
      placa: map['placa'],
      marca: map['marca'],
      modelo: map['modelo'],
      anio: map['anio'],
    );
  }
}
