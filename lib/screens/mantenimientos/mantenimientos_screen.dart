import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database_helper.dart';
import '../../models/mantenimiento.dart';
import '../../providers/app_provider.dart';
import 'agregar_mantenimiento_screen.dart'; // Importación vital para que no salga error

class MantenimientosScreen extends StatefulWidget {
  const MantenimientosScreen({super.key});

  @override
  State<MantenimientosScreen> createState() => _MantenimientosScreenState();
}

class _MantenimientosScreenState extends State<MantenimientosScreen> {
  List<Mantenimiento> _listaMantenimientos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMantenimientos();
  }

  Future<void> _cargarMantenimientos() async {
    final mantenimientos = await DatabaseHelper.obtenerMantenimientos();
    if (mounted) {
      setState(() {
        mantenimientos.sort((a, b) => a.estado.compareTo(b.estado));
        _listaMantenimientos = mantenimientos;
        _cargando = false;
      });
    }
  }

  Future<void> _navegarAgregar() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgregarMantenimientoScreen(),
      ),
    );
    if (result == true) {
      await _cargarMantenimientos();
    }
  }

  void _mostrarSelectorEstado(Mantenimiento mant) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Actualizar Estado',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _buildEstadoOpcion(
                  mant,
                  'Pendiente',
                  Icons.warning_amber_rounded,
                  Colors.redAccent,
                ),
                _buildEstadoOpcion(
                  mant,
                  'En proceso',
                  Icons.build_circle_rounded,
                  Colors.blue,
                ),
                _buildEstadoOpcion(
                  mant,
                  'Atendido',
                  Icons.check_circle_rounded,
                  Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstadoOpcion(
    Mantenimiento mant,
    String nuevoEstado,
    IconData icon,
    Color color,
  ) {
    final bool esActual = mant.estado == nuevoEstado;
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        nuevoEstado,
        style: TextStyle(
          fontWeight: esActual ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      trailing: esActual ? const Icon(Icons.check, color: Colors.grey) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () async {
        Navigator.pop(context);
        if (!esActual) {
          final updatedMant = Mantenimiento(
            id: mant.id,
            vehiculoPlaca: mant.vehiculoPlaca,
            falla: mant.falla,
            fecha: mant.fecha,
            estado: nuevoEstado,
          );

          await DatabaseHelper.insertMantenimiento(updatedMant);
          await _cargarMantenimientos();

          // Corrección de las llaves del 'if' que pedía la advertencia
          if (mounted) {
            context.read<AppProvider>().cargarContadores();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeaderCard(),
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : _listaMantenimientos.isEmpty
                ? _buildEmptyState(isDark)
                : _buildListView(isDark),
          ),
        ],
      ),
      floatingActionButton: _listaMantenimientos.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              label: const Text(
                'Registrar Falla',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: _navegarAgregar,
            )
          : null,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.build_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taller Mecánico',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Gestión de reparaciones y estados',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.build_rounded,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'No hay servicios registrados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Registra una falla o mantenimiento seleccionando un vehículo de tu flota.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _navegarAgregar,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Registrar falla',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  elevation: 5,
                  shadowColor: Colors.orange.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      itemCount: _listaMantenimientos.length,
      itemBuilder: (context, index) {
        final m = _listaMantenimientos[index];

        Color colorEstado = Colors.grey;
        if (m.estado == 'Pendiente') colorEstado = Colors.redAccent;
        if (m.estado == 'En proceso') colorEstado = Colors.blue;
        if (m.estado == 'Atendido') colorEstado = Colors.green;

        return Container(
          margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border(left: BorderSide(color: colorEstado, width: 5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.build_rounded,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Placa: ${m.vehiculoPlaca}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        m.falla,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        m.fecha,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _mostrarSelectorEstado(m),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorEstado.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorEstado.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.edit_note_rounded,
                          color: colorEstado,
                          size: 18,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.estado,
                          style: TextStyle(
                            color: colorEstado,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
