import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../registro/registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Conductor';

  final List<String> _roles = [
    'Conductor',
    'Dueño de vehículo',
    'Taller mecánico',
    'Administrador de flota',
  ];

  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando sesión como $_selectedRole...'),
          backgroundColor: const Color(0xFF1565C0),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Fondo con Degradado Profesional
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF42A5F5), // Azul claro
              Color(0xFF1565C0), // Azul oscuro MotoCheck
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 40.0,
            ),
            child: Card(
              elevation: 10, // Sombra más pronunciada
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Bordes más suaves
              ),
              color: Colors.white.withValues(
                alpha: 0.95,
              ), // Blanco ligeramente translúcido
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 2. Uso del Logo Oficial
                      const Image(
                        image: AssetImage("lib/Assets/Motos.png"),
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'MOTOCHECK',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1565C0),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        'Control de Mantenimiento',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 3. Campos de Entrada Modernizados
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        decoration: _inputStyle(
                          'Perfil de Usuario',
                          Icons.badge,
                        ),
                        items: _roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        decoration: _inputStyle(
                          'Correo Electrónico',
                          Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingrese su correo'
                            : null,
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        decoration: _inputStyle(
                          'Contraseña',
                          Icons.lock_outline,
                        ),
                        obscureText: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingrese su contraseña'
                            : null,
                      ),
                      const SizedBox(height: 30),

                      // 4. Botón Principal Mejorado
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFC107,
                            ), // Amarillo vibrante
                            foregroundColor: Colors.black87,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'INGRESAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Botón de texto secundario
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistroScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1565C0),
                        ),
                        child: const Text(
                          '¿No tienes cuenta? Regístrate aquí',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para el estilo de los inputs
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.grey[100], // Fondo suave
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none, // Sin borde duro por defecto
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF1565C0),
          width: 2,
        ), // Borde azul al escribir
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}
