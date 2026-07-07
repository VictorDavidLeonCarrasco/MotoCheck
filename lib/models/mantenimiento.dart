class Mantenimiento {
  String? id;
  String vehiculoPlaca;
  String falla;
  String fecha;
  String estado;
  String? fotoUrl;

  Mantenimiento({
    this.id,
    required this.vehiculoPlaca,
    required this.falla,
    required this.fecha,
    required this.estado,
    this.fotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehiculoPlaca': vehiculoPlaca,
      'falla': falla,
      'fecha': fecha,
      'estado': estado,
      'fotoUrl': fotoUrl,
    };
  }

  factory Mantenimiento.fromMap(Map<String, dynamic> map, String docId) {
    return Mantenimiento(
      id: docId,
      vehiculoPlaca: map['vehiculoPlaca'] ?? '',
      falla: map['falla'] ?? '',
      fecha: map['fecha'] ?? '',
      estado: map['estado'] ?? 'Pendiente',
      fotoUrl: map['fotoUrl'],
    );
  }
}
