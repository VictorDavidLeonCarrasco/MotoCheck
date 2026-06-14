// Archivo: lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../vehiculos/agregar_vehiculo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          'MotoCheck',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Cabecera con Imagen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Image(image: AssetImage("lib/Assets/Motos.png"), height: 140),
                  SizedBox(height: 10),
                  Text(
                    "Bienvenido a MotoCheck",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Control de mantenimiento de mototaxis y taxis",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Tarjetas informativas
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    Icons.directions_car,
                    "Vehículos",
                    "12",
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildCard(
                    Icons.build,
                    "Servicios",
                    "8",
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    Icons.history,
                    "Historial",
                    "25",
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildCard(
                    Icons.warning,
                    "Pendientes",
                    "3",
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Botón Registrar Vehículo
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgregarVehiculoScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Registrar Vehículo",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Vehículos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Mantenimiento",
          ),
        ],
      ),
    );
  }

  static Widget _buildCard(
    IconData icon,
    String titulo,
    String cantidad,
    Color color,
  ) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            cantidad,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(titulo, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
