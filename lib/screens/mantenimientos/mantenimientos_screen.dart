import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';
import 'agregar_mantenimiento_screen.dart';

class MantenimientosScreen extends StatefulWidget {
  const MantenimientosScreen({super.key});

  @override
  State<MantenimientosScreen> createState() => _MantenimientosScreenState();
}

class _MantenimientosScreenState extends State<MantenimientosScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Mantenimiento>>(
        future: DatabaseHelper.obtenerMantenimientos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay servicios registrados.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final m = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.build, color: Colors.orange),
                  title: Text(
                    'Placa: ${m.vehiculoPlaca}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Falla: ${m.falla}\nEstado: ${m.estado}'),
                  trailing: Text(m.fecha),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarMantenimientoScreen(),
            ),
          );
          _refresh();
        },
      ),
    );
  }
}
