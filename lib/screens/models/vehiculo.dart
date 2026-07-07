class Vehiculo {
  String? id; // ¡Cambiado a String para la nube!
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
    return {'placa': placa, 'marca': marca, 'modelo': modelo, 'anio': anio};
  }

  factory Vehiculo.fromMap(Map<String, dynamic> map, String docId) {
    return Vehiculo(
      id: docId, // Firebase nos da el ID aparte
      placa: map['placa'] ?? '',
      marca: map['marca'] ?? '',
      modelo: map['modelo'] ?? '',
      anio: map['anio'] ?? 0,
    );
  }
}
