import 'package:flutter/material.dart';
import 'detalle_mantenimiento_screen.dart';

void main() {
  runApp(const DetalleMantenimientoPreview());
}

class DetalleMantenimientoPreview extends StatelessWidget {
  const DetalleMantenimientoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detalle de mantenimiento',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1565C0),
      ),
      home: const DetalleMantenimientoScreen(
        placa: 'ABC-123',
        marca: 'Toyota',
        modelo: 'Corolla',
        anio: 2022,
        kilometraje: 45280,
      ),
    );
  }
}
