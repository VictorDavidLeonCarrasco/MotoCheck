import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _rolSeleccionado = 'Conductor';
  bool _ocultarPassword = true;
  bool _isLoading = false;

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) {
        return;
      }

      String idIngresado = _idController.text.trim();
      String tipoIdentificador = idIngresado.contains('@') ? idIngresado : 'DNI: $idIngresado';

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            rol: _rolSeleccionado,
            nombreUsuario: _nombreController.text.trim(),
            correoUsuario: tipoIdentificador,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.two_wheeler_rounded, size: 60, color: Color(0xFF1565C0)),
                  const SizedBox(height: 10),
                  const Text('CREAR CUENTA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1565C0), letterSpacing: 1.0)),
                  const SizedBox(height: 5),
                  const Text('Únete a MotoCheck', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 30),

                  DropdownButtonFormField<String>(
                    initialValue: _rolSeleccionado, // CORREGIDO AQUÍ
                    decoration: _inputStyle('Perfil de Usuario', Icons.badge_rounded),
                    items: ['Conductor', 'Taller mecánico', 'Administrador de flota'].map((String rol) {
                      return DropdownMenuItem<String>(value: rol, child: Text(rol, style: const TextStyle(fontWeight: FontWeight.bold)));
                    }).toList(),
                    onChanged: (String? newValue) => setState(() => _rolSeleccionado = newValue!),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputStyle('Nombre Completo', Icons.person_rounded),
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return 'Ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _idController,
                    decoration: _inputStyle('DNI o Correo Electrónico', Icons.contact_mail_rounded),
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return 'Dato obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF1565C0)),
                      suffixIcon: IconButton(
                        icon: Icon(_ocultarPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
                    ),
                    validator: (v) {
                      if (v!.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: _isLoading 
                        ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 3))
                        : const Text('REGISTRARSE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
    );
  }
}
