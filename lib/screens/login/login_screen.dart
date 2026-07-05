import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Agregamos SingleTickerProviderStateMixin para manejar animaciones fluidas
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Conductor';

  final List<String> _roles = [
    'Conductor',
    'Dueño de vehículo',
    'Taller mecánico',
    'Administrador de flota',
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animación de aparición suave al abrir la app
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(rol: _selectedRole)),
      );
    }
  }

  // --- FUNCIÓN PARA ABRIR EL REGISTRO INTERACTIVO ---
  void _mostrarRegistroBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _RegistroInteractivo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF121212), const Color(0xFF0D47A1)]
                : [const Color(0xFF42A5F5), const Color(0xFF1565C0)],
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: isDark
                    ? const Color(0xFF1E1E1E).withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alineación estructurada a la izquierda
                      children: [
                        // Logo alineado a la izquierda por diseño
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.two_wheeler,
                            size: 70,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'MOTOCHECK',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1565C0),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Control de Mantenimiento',
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 35),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedRole,
                          dropdownColor: isDark
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          decoration: _inputStyle(
                            'Perfil de Usuario',
                            Icons.badge,
                            isDark,
                          ),
                          items: _roles
                              .map(
                                (String role) => DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) =>
                              setState(() => _selectedRole = newValue!),
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: _inputStyle(
                            'Correo Electrónico',
                            Icons.email_outlined,
                            isDark,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Ingrese su correo'
                              : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: _inputStyle(
                            'Contraseña',
                            Icons.lock_outline,
                            isDark,
                          ),
                          obscureText: true,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Ingrese su contraseña'
                              : null,
                        ),
                        const SizedBox(height: 35),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _iniciarSesion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
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

                        Center(
                          child: TextButton(
                            onPressed: _mostrarRegistroBottomSheet,
                            style: TextButton.styleFrom(
                              foregroundColor: isDark
                                  ? const Color(0xFF64B5F6)
                                  : const Color(0xFF1565C0),
                            ),
                            child: const Text(
                              '¿No tienes cuenta? Regístrate aquí',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
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
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      prefixIcon: Icon(
        icon,
        color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}

// ============================================================================
// WIDGET DEL BOTTOM SHEET DE REGISTRO INTERACTIVO CON API DNI
// ============================================================================
class _RegistroInteractivo extends StatefulWidget {
  const _RegistroInteractivo();

  @override
  State<_RegistroInteractivo> createState() => _RegistroInteractivoState();
}

class _RegistroInteractivoState extends State<_RegistroInteractivo> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();
  final _nombreController = TextEditingController();
  bool _cargandoDNI = false;

  Future<void> _buscarDNI() async {
    final dni = _dniController.text.trim();
    if (dni.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El DNI debe tener 8 dígitos')),
      );
      return;
    }

    setState(() {
      _cargandoDNI = true;
      _nombreController.clear();
    });

    try {
      // --- USO DE TOKEN PERSONAL APISPERU.COM ---
      const String token =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImVtcGlyb3Rlc21pdEBvdXRsb29rLmNvbSJ9.XeRQDaLAKPy_MHPjRLJYFYs8ZL5W2-M_NWR8YZOlw08';
      final url = Uri.parse(
        'https://dniruc.apisperu.com/api/v1/dni/$dni?token=$token',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // APISPERU devuelve los datos separados, los concatenamos
        if (data['nombres'] != null) {
          final nombreCompleto =
              '${data['nombres']} ${data['apellidoPaterno']} ${data['apellidoMaterno']}';
          setState(() => _nombreController.text = nombreCompleto);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudieron extraer los datos')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('DNI no encontrado o error en la API')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      setState(() => _cargandoDNI = false);
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detecta el teclado para empujar el BottomSheet hacia arriba y que no tape los inputs
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomInset,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pequeña barra indicadora de arrastre
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Crear Nueva Cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // CAMPO DNI + BOTÓN DE BÚSQUEDA ANIMADO
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dniController,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Ingresa tu DNI',
                        counterText: "",
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 55,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: _cargandoDNI ? null : _buscarDNI,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _cargandoDNI
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.search, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // CAMPO NOMBRE AUTOCOMPLETADO
              TextFormField(
                controller: _nombreController,
                readOnly:
                    true, // El usuario no debería editar lo que viene del Reniec
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nombre Automático',
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Busca tu DNI primero' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Crea una contraseña',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context); // Cierra el BottomSheet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cuenta registrada con éxito. ¡Ya puedes ingresar!',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'COMPLETAR REGISTRO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
