import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../database/database_helper.dart';
import '../../models/vehiculo.dart';
import '../../providers/app_provider.dart';

class AgregarVehiculoScreen extends StatefulWidget {
  final Vehiculo? vehiculo;
  const AgregarVehiculoScreen({super.key, this.vehiculo});

  @override
  State<AgregarVehiculoScreen> createState() => _AgregarVehiculoScreenState();
}

class _AgregarVehiculoScreenState extends State<AgregarVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anioController = TextEditingController();

  String _tipoSeleccionado = 'Auto';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehiculo != null) {
      _placaController.text = widget.vehiculo!.placa;
      _marcaController.text = widget.vehiculo!.marca;
      _modeloController.text = widget.vehiculo!.modelo;
      _anioController.text = widget.vehiculo!.anio.toString();
    }
  }

  void _actualizarFormatoPlaca() {
    String rawText = _placaController.text.replaceAll('-', '');
    if (rawText.isEmpty) {
      return;
    }

    String formatted = _aplicarMascaraPlaca(rawText, _tipoSeleccionado);

    _placaController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _aplicarMascaraPlaca(String text, String tipo) {
    String cleanText = text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (cleanText.length > 6) {
      cleanText = cleanText.substring(0, 6);
    }

    if (tipo == 'Auto') {
      if (cleanText.length > 3) {
        return '${cleanText.substring(0, 3)}-${cleanText.substring(3)}';
      }
      return cleanText;
    } else {
      bool startsWithNumber = RegExp(r'^[0-9]').hasMatch(cleanText);
      if (startsWithNumber) {
        if (cleanText.length > 4) {
          return '${cleanText.substring(0, 4)}-${cleanText.substring(4)}';
        }
      } else {
        if (cleanText.length > 2) {
          return '${cleanText.substring(0, 2)}-${cleanText.substring(2)}';
        }
      }
      return cleanText;
    }
  }

  Future<void> _guardarVehiculo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final v = Vehiculo(
        id: widget.vehiculo?.id,
        placa: _placaController.text,
        marca: _marcaController.text,
        modelo: _modeloController.text,
        anio: int.parse(_anioController.text),
      );

      if (widget.vehiculo == null) {
        await DatabaseHelper.insertVehiculo(v);
      } else {
        await DatabaseHelper.updateVehiculo(v);
      }

      if (!mounted) {
        return;
      }
      Provider.of<AppProvider>(context, listen: false).actualizarDatos();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.vehiculo == null
                    ? 'Vehículo registrado'
                    : 'Vehículo actualizado',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _placaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.vehiculo != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          esEdicion ? 'Editar Vehículo' : 'Registrar Vehículo',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F7FA), const Color(0xFFE3E9F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTipoToggle(
                            'Auto',
                            Icons.directions_car_rounded,
                            isDark,
                          ),
                          _buildTipoToggle(
                            'Moto',
                            Icons.two_wheeler_rounded,
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _placaController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    decoration: _inputStyle(
                      'Placa del vehículo',
                      Icons.tag,
                      isDark,
                    ),
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String formatted = _aplicarMascaraPlaca(
                          newValue.text,
                          _tipoSeleccionado,
                        );
                        return TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }),
                    ],
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Ingrese la placa';
                      }
                      if (v.length < 7) {
                        return 'Placa incompleta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _marcaController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputStyle(
                      'Marca',
                      Icons.branding_watermark_rounded,
                      isDark,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
                      ),
                    ],
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return 'Ingrese la marca';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _modeloController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputStyle(
                      'Modelo',
                      Icons.car_repair_rounded,
                      isDark,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s\-]'),
                      ),
                    ],
                    validator: (v) {
                      if (v!.trim().isEmpty) {
                        return 'Ingrese el modelo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _anioController,
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle(
                      'Año de fabricación',
                      Icons.calendar_today_rounded,
                      isDark,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Ingrese el año';
                      }
                      if (v.length != 4) {
                        return 'El año debe tener 4 dígitos';
                      }
                      int anio = int.parse(v);
                      int anioActual = DateTime.now().year;
                      if (anio < 1950 || anio > anioActual + 1) {
                        return 'Año inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _guardarVehiculo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black87,
                        elevation: _isSaving ? 0 : 5,
                        shadowColor: const Color(
                          0xFFFFC107,
                        ).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: Colors.black87,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              esEdicion
                                  ? 'ACTUALIZAR VEHÍCULO'
                                  : 'GUARDAR VEHÍCULO',
                              style: const TextStyle(
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
        ),
      ),
    );
  }

  Widget _buildTipoToggle(String tipo, IconData icon, bool isDark) {
    bool isSelected = _tipoSeleccionado == tipo;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoSeleccionado = tipo;
          _actualizarFormatoPlaca();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              tipo,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white70 : Colors.black54,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
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
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
