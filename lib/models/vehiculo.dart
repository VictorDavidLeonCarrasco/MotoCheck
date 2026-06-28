class Vehiculo {
  final int? id; // Corregido: SQLite usa int para AUTOINCREMENT
  final String placa;
  final String marca;
  final String modelo;
  final int anio;
  final String color;

  const Vehiculo({
    this.id, // Opcional al crear uno nuevo
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.color = '',
  });

  // Corregido: fromMap en lugar de fromJson
  factory Vehiculo.fromMap(Map<String, dynamic> map) {
    return Vehiculo(
      id: map['id'] as int?,
      placa: map['placa']?.toString() ?? '',
      marca: map['marca']?.toString() ?? '',
      modelo: map['modelo']?.toString() ?? '',
      anio: map['anio'] as int? ?? 0,
      color: map['color']?.toString() ?? '',
    );
  }

  // Corregido: toMap en lugar de toJson
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'color': color,
    };
  }
}
