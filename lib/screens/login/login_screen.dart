import 'package:control_de_mototaxis_o_taxis/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Conductor';

  // Lista de roles requeridos
  final List<String> _roles = [
    'Conductor',
    'Dueño de vehículo',
    'Taller mecánico',
    'Administrador de flota',
  ];

  // Función de inicio de sesión modificada para enviar el rol al HomeScreen
  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
<<<<<<< HEAD
=======
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando sesión como $_selectedRole...'),
          backgroundColor: const Color(0xFF1565C0),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // PASO 4 CORREGIDO: Se pasa el '_selectedRole' a la propiedad 'rol' del HomeScreen
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(rol: _selectedRole)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Card(
            // Uso de Card sugerido en los requisitos
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.two_wheeler, size: 80, color: Colors.blueAccent),
                    SizedBox(height: 20),
                    Text(
                      'Control de Mantenimiento',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
=======
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
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              // Corregido con el estándar moderno .withValues
              color: Colors.white.withValues(alpha: 0.95),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo oficial de MotoCheck
                      const Image(
                        image: AssetImage("lib/Assets/Motos.png"),
                        height: 100,
                        fit: BoxFit.contain,
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

<<<<<<< HEAD
                    // Selección de usuario
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        labelText:
                            'Perfil de Usuario', // Componente InputFields
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
=======
                      // Dropdown del Perfil de Usuario
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
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
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
                    SizedBox(height: 15),

<<<<<<< HEAD
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
=======
                      // Campo Correo Electrónico
                      TextFormField(
                        decoration: _inputStyle(
                          'Correo Electrónico',
                          Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingrese su correo'
                            : null,
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        // Validación básica de formulario
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

<<<<<<< HEAD
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
=======
                      // Campo Contraseña
                      TextFormField(
                        decoration: _inputStyle(
                          'Contraseña',
                          Icons.lock_outline,
                        ),
                        obscureText: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Ingrese su contraseña'
                            : null,
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
                      ),
                      obscureText: true,
                      validator: (value) {
                        // Validación básica de formulario
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

<<<<<<< HEAD
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _iniciarSesion,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
=======
                      // Botón Ingresar
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFC107,
                            ), // Amarillo
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
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
                          ),
                        ),
                        child: Text('Ingresar', style: TextStyle(fontSize: 18)),
                      ),
<<<<<<< HEAD
                    ),
                  ],
=======
                      const SizedBox(height: 15),

                      // Enlace a la pantalla de Registro
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
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  // Estilo personalizado para los inputs
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
}
