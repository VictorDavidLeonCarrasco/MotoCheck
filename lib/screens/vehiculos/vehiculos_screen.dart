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
  List<Vehiculo> _todosLosVehiculos = [];
  List<Vehiculo> _vehiculosFiltrados = [];
  bool _cargando = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  // --- FUNCIÓN QUE CARGA Y ACTUALIZA LA LISTA ---
  Future<void> _cargarVehiculos() async {
    final vehiculos = await DatabaseHelper.obtenerVehiculos();
    if (!mounted) return;

    setState(() {
      _todosLosVehiculos = vehiculos;
      // Mantenemos el filtro actual si el usuario estaba buscando algo
      if (_searchController.text.isEmpty) {
        _vehiculosFiltrados = vehiculos;
      } else {
        _filtrarBusqueda(_searchController.text);
      }
      _cargando = false;
    });
  }

  // --- LA CLAVE PARA ACTUALIZAR EL DASHBOARD Y LA LISTA ---
  Future<void> _navegarAgregarEditar([Vehiculo? vehiculo]) async {
    // 1. Esperamos a que la pantalla de registro se cierre
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarVehiculoScreen(vehiculo: vehiculo),
      ),
    );

    // 2. Si devolvió 'true' (significa que guardó algo), actualizamos todo
    if (result == true) {
      // Actualizamos la lista de esta pantalla
      await _cargarVehiculos();

      // Actualizamos los íconos numéricos del Dashboard (AppProvider)
      if (mounted) {
        context.read<AppProvider>().cargarContadores();
      }
    }
  }

  Future<void> _eliminarVehiculo(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Eliminar Vehículo'),
        content: const Text(
          '¿Estás seguro de eliminar este vehículo de tu flota?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
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
      await DatabaseHelper.deleteVehiculo(id);
      await _cargarVehiculos();
      if (mounted) {
        context.read<AppProvider>().cargarContadores();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vehículo eliminado'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    }
  }

  void _filtrarBusqueda(String query) {
    setState(() {
      if (query.isEmpty) {
        _vehiculosFiltrados = _todosLosVehiculos;
      } else {
        _vehiculosFiltrados = _todosLosVehiculos.where((v) {
          final textoBusqueda = query.toLowerCase();
          return v.placa.toLowerCase().contains(textoBusqueda) ||
              v.marca.toLowerCase().contains(textoBusqueda) ||
              v.modelo.toLowerCase().contains(textoBusqueda);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // 1. HEADER AZUL PREMIUM
          _buildHeaderCard(),

          // 2. BUSCADOR
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filtrarBusqueda,
              decoration: InputDecoration(
                hintText: 'Buscar por placa, marca o modelo',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? Colors.white70 : Colors.blue.shade700,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isDark ? Colors.transparent : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF1565C0),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // 3. CONTENIDO (LISTA O ESTADO VACÍO)
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                  )
                : _todosLosVehiculos.isEmpty
                ? _buildEmptyState(isDark)
                : _vehiculosFiltrados.isEmpty
                ? Center(
                    child: Text(
                      'No hay resultados para la búsqueda',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  )
                : _buildListView(isDark),
          ),
        ],
      ),
      // BOTÓN FLOTANTE (Solo se muestra si hay vehículos, si está vacío ya hay un botón gigante)
      floatingActionButton: _todosLosVehiculos.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFFFFC107),
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.black87, size: 22),
              label: const Text(
                'Registrar vehículo',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: () => _navegarAgregarEditar(),
            )
          : null,
    );
  }

  // --- TARJETA SUPERIOR AZUL ---
  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis vehículos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Administra tu flota y sus mantenimientos',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- DISEÑO CUANDO NO HAY VEHÍCULOS ---
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
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.grey.shade200,
          ),
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
            Text(
              'No hay vehículos registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Registra tu primer vehículo para comenzar a controlar sus servicios y mantenimientos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _navegarAgregarEditar(),
                icon: const Icon(Icons.add, color: Colors.black87),
                label: const Text(
                  'Agregar vehículo',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  elevation: 5,
                  shadowColor: const Color(0xFFFFC107).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LISTA DE VEHÍCULOS ---
  Widget _buildListView(bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 80,
      ), // Margen inferior para el FAB
      itemCount: _vehiculosFiltrados.length,
      itemBuilder: (context, index) {
        final v = _vehiculosFiltrados[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
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
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _navegarAgregarEditar(v),
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
                            '${v.marca} ${v.modelo}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  v.placa,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Año: ${v.anio}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _eliminarVehiculo(v.id!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
