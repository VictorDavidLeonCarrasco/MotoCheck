import 'package:control_de_mototaxis_o_taxis/screens/vehiculos/agregar_vehiculo_screen.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class VehiculosScreen extends StatefulWidget {
  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehículos')),
      body: Center(child: Text('Pantalla de Vehículos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarVehiculoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
