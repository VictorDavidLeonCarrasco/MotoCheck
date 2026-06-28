import 'package:flutter/material.dart';

import 'agregar_vehiculo_screen.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  static const Color _azulPrincipal = Color(0xFF1565C0);
  static const Color _amarillo = Color(0xFFFFC107);

  Future<void> _abrirRegistroVehiculo() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const AgregarVehiculoScreen();
        },
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _actualizarPantalla() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: modoOscuro
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: _actualizarPantalla,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          children: [
            _buildEncabezado(modoOscuro),
            const SizedBox(height: 20),
            _buildBuscador(),
            const SizedBox(height: 24),
            _buildEstadoVacio(modoOscuro),
            const SizedBox(height: 90),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirRegistroVehiculo,
        backgroundColor: _amarillo,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Registrar vehículo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEncabezado(bool modoOscuro) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _azulPrincipal.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 37,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis vehículos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Administra tu flota y sus mantenimientos',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuscador() {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: 'Buscar por placa, marca o modelo',
        prefixIcon: const Icon(Icons.search_rounded, color: _azulPrincipal),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildEstadoVacio(bool modoOscuro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        color: modoOscuro ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: modoOscuro ? Colors.white12 : const Color(0xFFE1E7EE),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: _azulPrincipal.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.no_crash_outlined,
              size: 49,
              color: _azulPrincipal,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No hay vehículos registrados',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 9),
          const Text(
            'Registra tu primer vehículo para comenzar a controlar sus servicios y mantenimientos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _abrirRegistroVehiculo,
            style: ElevatedButton.styleFrom(
              backgroundColor: _amarillo,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Agregar vehículo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
