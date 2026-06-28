import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/vehiculo.dart';
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

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    final vehiculos = await DatabaseHelper.obtenerVehiculos();
    setState(() {
      _todosLosVehiculos = vehiculos;
      _vehiculosFiltrados = vehiculos;
      _cargando = false;
    });
  }

  void _filtrarBusqueda(String query) {
    setState(() {
      if (query.isEmpty) {
        _vehiculosFiltrados = _todosLosVehiculos;
      } else {
        _vehiculosFiltrados = _todosLosVehiculos.where((v) {
          return v.placa.toLowerCase().contains(query.toLowerCase()) ||
              v.marca.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // --- BARRA DE BÚSQUEDA ---
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: _filtrarBusqueda,
              decoration: InputDecoration(
                labelText: 'Buscar por placa o marca...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- LISTA DE VEHÍCULOS ---
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _vehiculosFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron vehículos.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _vehiculosFiltrados.length,
                    itemBuilder: (context, index) {
                      final v = _vehiculosFiltrados[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF1565C0),
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '${v.marca} ${v.modelo}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text('Placa: ${v.placa} | Año: ${v.anio}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AgregarVehiculoScreen(vehiculo: v),
                                    ),
                                  );
                                  _cargarVehiculos();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFC107),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarVehiculoScreen(),
            ),
          );
          _cargarVehiculos();
        },
      ),
    );
  }
}
