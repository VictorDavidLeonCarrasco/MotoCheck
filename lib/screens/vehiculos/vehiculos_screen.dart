import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database_helper.dart';
import '../../models/vehiculo.dart';
import '../../providers/app_provider.dart';
import 'agregar_vehiculo_screen.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<Vehiculo> _vehiculos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  // --- FUNCIÓN MEJORADA CON MANEJO DE ERRORES ---
  Future<void> _cargarVehiculos() async {
    try {
      final vehiculos = await DatabaseHelper.obtenerVehiculos();
      if (mounted) {
        setState(() {
          _vehiculos = vehiculos;
          _cargando = false; // Apagamos el spinner con éxito
        });
      }
    } catch (e) {
      debugPrint('Error al cargar vehículos: $e');
      if (mounted) {
        setState(
          () => _cargando = false,
        ); // Apagamos el spinner incluso si falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexión a la nube: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _eliminarVehiculo(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Eliminar Vehículo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este vehículo de la flota?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await DatabaseHelper.deleteVehiculo(id);
        await _cargarVehiculos();
        if (mounted) {
          context.read<AppProvider>().cargarContadores();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Vehículo eliminado correctamente'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            )
          : _vehiculos.isEmpty
          ? _buildEmptyState(isDark)
          : _buildListaVehiculos(isDark),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Vehículo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarVehiculoScreen()),
          );
          if (result == true) _cargarVehiculos();
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                size: 60,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Sin vehículos registrados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'Agrega el primer vehículo a tu flota para comenzar el seguimiento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaVehiculos(bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 15, bottom: 90, left: 20, right: 20),
      itemCount: _vehiculos.length,
      itemBuilder: (context, index) {
        final v = _vehiculos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: const Border(
              left: BorderSide(color: Color(0xFF1565C0), width: 5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Color(0xFF1565C0),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.placa,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${v.marca} ${v.modelo}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Año: ${v.anio}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AgregarVehiculoScreen(vehiculo: v),
                          ),
                        );
                        if (result == true) _cargarVehiculos();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _eliminarVehiculo(v.id!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
