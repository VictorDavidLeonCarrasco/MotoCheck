import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';
import '../../models/vehiculo.dart';
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
  final _fallaController = TextEditingController();

  String _estadoSeleccionado = 'Pendiente';
  String? _placaSeleccionada;
  List<Vehiculo> _vehiculosDisponibles = [];
  bool _cargandoVehiculos = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    final vehiculos = await DatabaseHelper.obtenerVehiculos();
    if (mounted) {
      setState(() {
        _vehiculosDisponibles = vehiculos;
        _cargandoVehiculos = false;
      });
    }
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final mant = Mantenimiento(
          vehiculoPlaca: _placaSeleccionada!,
          falla: _fallaController.text,
          fecha: DateTime.now().toString().substring(0, 10),
          estado: _estadoSeleccionado,
        );

        await DatabaseHelper.insertMantenimiento(mant);

        if (!mounted) {
          return;
        }
        Provider.of<AppProvider>(context, listen: false).actualizarDatos();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Servicio registrado exitosamente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _fallaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Registrar Falla',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F7FA), const Color(0xFFE3E9F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.build_circle_rounded,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _cargandoVehiculos
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          initialValue: _placaSeleccionada,
                          dropdownColor: isDark
                              ? const Color(0xFF2C2C2C)
                              : Colors.white,
                          decoration: _inputStyle(
                            'Seleccionar Vehículo',
                            Icons.directions_car_rounded,
                            isDark,
                          ),
                          items: _vehiculosDisponibles.map((Vehiculo v) {
                            return DropdownMenuItem<String>(
                              value: v.placa,
                              child: Text(
                                '${v.placa} - ${v.marca} ${v.modelo}',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) =>
                              setState(() => _placaSeleccionada = newValue),
                          validator: (value) => value == null
                              ? 'Por favor seleccione un vehículo'
                              : null,
                        ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _fallaController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputStyle(
                      'Descripción de la falla',
                      Icons.plumbing_rounded,
                      isDark,
                    ),
                    maxLines: 3,
                    validator: (v) => v!.trim().isEmpty
                        ? 'La descripción es obligatoria'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    initialValue: _estadoSeleccionado,
                    dropdownColor: isDark
                        ? const Color(0xFF2C2C2C)
                        : Colors.white,
                    decoration: _inputStyle(
                      'Estado inicial',
                      Icons.info_outline_rounded,
                      isDark,
                    ),
                    items: ['Pendiente', 'En proceso', 'Atendido'].map((
                      String estado,
                    ) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(
                          estado,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) =>
                        setState(() => _estadoSeleccionado = newValue!),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: _isSaving ? 0 : 5,
                        shadowColor: Colors.orange.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'REGISTRAR MANTENIMIENTO',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white70 : Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: Colors.orange),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
