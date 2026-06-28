import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';
import '../../providers/app_provider.dart';

class AgregarMantenimientoScreen extends StatefulWidget {
  const AgregarMantenimientoScreen({super.key});

  @override
  State<AgregarMantenimientoScreen> createState() =>
      _AgregarMantenimientoScreenState();
}

class _AgregarMantenimientoScreenState
    extends State<AgregarMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _fallaController = TextEditingController();
  String _estadoSeleccionado = 'Pendiente';

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final mant = Mantenimiento(
          vehiculoPlaca: _placaController.text,
          falla: _fallaController.text,
          fecha: DateTime.now().toString().substring(0, 10),
          estado: _estadoSeleccionado,
        );

        await DatabaseHelper.insertMantenimiento(mant);

        if (!mounted) return;
        // Avisamos a Provider que actualice todo
        Provider.of<AppProvider>(context, listen: false).actualizarDatos();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Servicio registrado exitosamente')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Falla',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode:
              AutovalidateMode.onUserInteraction, // Validación visual en vivo
          child: Column(
            children: [
              Hero(
                // Animación fluida al abrir la pantalla
                tag: 'icono_taller',
                child: const Icon(
                  Icons.build_circle,
                  size: 80,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(
                  labelText: 'Placa del Vehículo',
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Por favor ingrese la placa' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fallaController,
                decoration: InputDecoration(
                  labelText: 'Descripción de la Falla',
                  prefixIcon: const Icon(Icons.plumbing),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                maxLines: 3,
                validator: (v) =>
                    v!.isEmpty ? 'La descripción es obligatoria' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Estado del Servicio',
                  prefixIcon: const Icon(Icons.info),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Estados precisos actualizados
                items: ['Pendiente', 'En proceso', 'Atendido']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _estadoSeleccionado = v!),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
