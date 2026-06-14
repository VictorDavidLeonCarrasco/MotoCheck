/// Modelo de datos para un vehículo.///
/// Incluye serialización JSON básica para facilitar el uso en pantallas y servicios.
class Vehiculo {
  final String id;
  final String placa;
  final String marca;
  final String modelo;
  final int anio;
  final String color;

  const Vehiculo({
    required this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.color,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id']?.toString() ?? '',
      placa: json['placa']?.toString() ?? '',
      marca: json['marca']?.toString() ?? '',
      modelo: json['modelo']?.toString() ?? '',
      anio: json['anio'] is int
          ? json['anio'] as int
          : int.tryParse(json['anio']?.toString() ?? '') ?? 0,
      color: json['color']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'color': color,
    };
  }

  Vehiculo copyWith({
    String? id,
    String? placa,
    String? marca,
    String? modelo,
    int? anio,
    String? color,
  }) {
    return Vehiculo(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Vehiculo(id: $id, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehiculo &&
        other.id == id &&
        other.placa == placa &&
        other.marca == marca &&
        other.modelo == modelo &&
        other.anio == anio &&
        other.color == color;
  }

  @override
  int get hashCode {
    return Object.hash(id, placa, marca, modelo, anio, color);
  }
}
