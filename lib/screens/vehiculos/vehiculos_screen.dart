import 'package:control_de_mototaxis_o_taxis/screens/vehiculos/agregar_vehiculo_screen.dart';
import 'package:flutter/material.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  List<Vehiculo> vehiculos = [];

  @override
  void initState() {
    super.initState();
    cargarVehiculos();
  }

  Future<void> cargarVehiculos() async {
    final lista = await DatabaseHelper().obtenerVehiculos();

    setState(() {
      vehiculos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Vehículos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/agregarVehiculo');
        },
        child: const Icon(Icons.add),
      ),
      body: vehiculos.isEmpty
          ? const Center(child: Text('No hay vehículos registrados'))
          : ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = vehiculos[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(vehiculo.placa),
                    subtitle: Text(
                      '${vehiculo.marca} ${vehiculo.modelo} - ${vehiculo.anio}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DatabaseHelper {
  Future<List<Vehiculo>> obtenerVehiculos() async {
    // Aquí iría la lógica real para obtener los vehículos desde SQLite
    // Por ahora, devolvemos una lista de ejemplo
    return [
      Vehiculo(
        id: 1,
        placa: 'ABC123',
        marca: 'Yamaha',
        modelo: 'YZF-R3',
        anio: 2020,
      ),
      Vehiculo(
        id: 2,
        placa: 'XYZ789',
        marca: 'Honda',
        modelo: 'CB500F',
        anio: 2019,
      ),
    ];
  }
}
