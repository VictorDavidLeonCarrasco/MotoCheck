import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';

class DetalleMantenimientoScreen extends StatefulWidget {
  const DetalleMantenimientoScreen({super.key});

  @override
  State<DetalleMantenimientoScreen> createState() =>
      _DetalleMantenimientoScreenState();
}

class _DetalleMantenimientoScreenState
    extends State<DetalleMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _fallaController = TextEditingController();
  String _estadoSeleccionado = 'Pendiente';

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final mant = Mantenimiento(
        vehiculoPlaca: _placaController.text,
        falla: _fallaController.text,
        fecha: DateTime.now().toString().substring(0, 10),
        estado: _estadoSeleccionado,
      );
      await DatabaseHelper.insertMantenimiento(mant);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falla registrada en el taller')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle del Mantenimiento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.build_circle, size: 60, color: Colors.orange),
              const SizedBox(height: 20),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa del Vehículo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fallaController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la Falla',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: ['Pendiente', 'En proceso', 'Terminado']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _estadoSeleccionado = v!),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Registrar Mantenimiento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
