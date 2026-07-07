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
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _ocultarPassword = true;
  bool _isLoading = false;

  Future<void> _ingresar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulamos un pequeño tiempo de carga de red
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      String idIngresado = _idController.text.trim();
      String passwordIngresado = _passwordController.text;

      String rolDesignado = '';
      String nombreDesignado = '';
      String correoDesignado = '';

      // ==========================================================
      // LÓGICA DE ROLES Y CREDENCIALES
      // ==========================================================
      if (idIngresado == 'prueba@correo.com' && passwordIngresado == '123456') {
        // PERFIL: TALLER MECÁNICO
        rolDesignado = 'Taller mecánico';
        nombreDesignado = 'Taller Oficial MotoCheck';
        correoDesignado = idIngresado;
      } else if (idIngresado == '76159606' && passwordIngresado == '123456') {
        // PERFIL: CONDUCTOR
        rolDesignado = 'Conductor';
        nombreDesignado = 'Humberto Moises Rojas Capcha';
        correoDesignado = 'DNI: $idIngresado';
      } else {
        // CREDENCIALES INCORRECTAS
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuario o contraseña incorrectos'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
        return; // Detenemos la ejecución aquí
      }

      // Si las credenciales son correctas, navegamos al Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            rol: rolDesignado,
            nombreUsuario: nombreDesignado,
            correoUsuario: correoDesignado,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.two_wheeler_rounded,
                    size: 60,
                    color: Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'MOTOCHECK',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1565C0),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Control de Mantenimiento',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  // Se eliminó el Dropdown de roles para que el sistema lo asigne automáticamente
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _idController,
                    decoration: _inputStyle(
                      'DNI o Correo Electrónico',
                      Icons.contact_mail_rounded,
                    ),
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Ingrese sus datos' : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF1565C0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _ocultarPassword = !_ocultarPassword,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF1565C0),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _ingresar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.black87,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'INGRESAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegistroScreen()),
                    ),
                    child: const Text(
                      '¿No tienes cuenta? Regístrate aquí',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
    );
  }
}
