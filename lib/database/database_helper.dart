import 'package:control_de_mototaxis_o_taxis/screens/vehiculos/agregar_vehiculo_screen.dart';

Future<List<Vehiculo>> obtenerVehiculos(Future<Object?> database) async {
  final db = await database;

  final List<Map<String, dynamic>>? maps = await db?.query('vehiculos');
  return List.generate(maps!.length, (i) => Vehiculo.fromMap(maps[i]));
}

extension on Object? {
  Future<List<Map<String, dynamic>>> query(String s) async {
    return [];
  }
}
