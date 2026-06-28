class Mantenimiento {
  final int? id;
  final String vehiculoPlaca;
  final String falla;
  final String fecha;
  final String estado;

  const Mantenimiento({
    this.id,
    required this.vehiculoPlaca,
    required this.falla,
    required this.fecha,
    required this.estado,
  });

  factory Mantenimiento.fromMap(Map<String, dynamic> map) {
    return Mantenimiento(
      id: map['id'] as int?,
      vehiculoPlaca: map['vehiculoPlaca']?.toString() ?? '',
      falla: map['falla']?.toString() ?? '',
      fecha: map['fecha']?.toString() ?? '',
      estado: map['estado']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehiculoPlaca': vehiculoPlaca,
      'falla': falla,
      'fecha': fecha,
      'estado': estado,
    };
  }
}
