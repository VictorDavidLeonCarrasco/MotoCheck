import 'package:flutter/material.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: const Center(child: Text('Pantalla de registro en construcción')),
    );
  }
}
