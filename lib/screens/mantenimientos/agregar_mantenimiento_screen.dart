import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';
import '../../models/vehiculo.dart';
import '../../providers/app_provider.dart';

class AgregarMantenimientoScreen extends StatefulWidget {
  const AgregarMantenimientoScreen({super.key});

  @override
  State<AgregarMantenimientoScreen> createState() =>
      _AgregarMantenimientoScreenState();
}

class _AgregarMantenimientoScreenState
    extends State<AgregarMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fallaController = TextEditingController();

  List<Vehiculo> _vehiculos = [];
  String? _placaSeleccionada;
  bool _isLoading = true;
  bool _isSaving = false;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    final vehiculos = await DatabaseHelper.obtenerVehiculos();
    if (mounted) {
      setState(() {
        _vehiculos = vehiculos;
        if (_vehiculos.isNotEmpty) {
          _placaSeleccionada = _vehiculos.first.placa;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
      );
      if (pickedFile != null) {
        setState(() => _imageFile = pickedFile);
      }
    } catch (e) {
      debugPrint("Error al seleccionar imagen: $e");
    }
  }

  void _mostrarOpcionesImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: Color(0xFF1565C0),
              ),
              title: const Text('Tomar Foto'),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: Color(0xFF1565C0),
              ),
              title: const Text('Subir desde Galería'),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarMantenimiento() async {
    // Solucionado: Uso de llaves { } en el if
    if (!_formKey.currentState!.validate() || _placaSeleccionada == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Como no usamos Storage, guardamos la ruta local directamente
      String? imageUrl = _imageFile?.path;

      final mant = Mantenimiento(
        vehiculoPlaca: _placaSeleccionada!,
        falla: _fallaController.text.trim(),
        fecha: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        estado: 'Pendiente',
        fotoUrl: imageUrl,
      );

      await DatabaseHelper.insertMantenimiento(mant);

      // Solucionado: Uso de llaves { } en el if
      if (!mounted) {
        return;
      }

      Provider.of<AppProvider>(context, listen: false).actualizarDatos();
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      // Solucionado: Uso de llaves { } en el if
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Registrar Mantenimiento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _vehiculos.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona el Vehículo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      // Solucionado: Se reemplazó 'value' por 'initialValue'
                      initialValue: _placaSeleccionada,
                      decoration: _inputStyle(
                        'Vehículo',
                        Icons.directions_car_rounded,
                      ),
                      items: _vehiculos
                          .map(
                            (v) => DropdownMenuItem(
                              value: v.placa,
                              child: Text(
                                '${v.placa} - ${v.marca}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _placaSeleccionada = v),
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      'Evidencia Fotográfica',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildImageSelector(),
                    const SizedBox(height: 25),

                    const Text(
                      'Descripción de la falla',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _fallaController,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _inputStyle(
                        'Detalles del problema',
                        Icons.build_circle_rounded,
                      ),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Ingrese la descripción' : null,
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _guardarMantenimiento,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF6C00),
                          foregroundColor: Colors.white,
                          elevation: _isSaving ? 0 : 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'GUARDAR REGISTRO',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: _mostrarOpcionesImagen,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 50,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Toca para subir una foto',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: kIsWeb
                    ? Image.network(
                        _imageFile!.path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.file(
                        File(_imageFile!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay vehículos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Primero debes registrar un vehículo para poder asignarle un mantenimiento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFEF6C00)),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFEF6C00), width: 2),
      ),
    );
  }
}
