import 'package:flutter/material.dart';

class DetalleMantenimientoScreen extends StatefulWidget {
  const DetalleMantenimientoScreen({
    super.key,
    this.placa = 'ABC-123',
    this.marca = 'Toyota',
    this.modelo = 'Corolla',
    this.anio = 2022,
    this.kilometraje = 45280,
  });

  final String placa;
  final String marca;
  final String modelo;
  final int anio;
  final int kilometraje;

  @override
  State<DetalleMantenimientoScreen> createState() =>
      _DetalleMantenimientoScreenState();
}

class _DetalleMantenimientoScreenState
    extends State<DetalleMantenimientoScreen> {
  static const Color _azul = Color(0xFF1565C0);
  static const Color _azulOscuro = Color(0xFF0D47A1);
  static const Color _amarillo = Color(0xFFFFC107);
  static const Color _fondo = Color(0xFFF5F7FA);
  static const Color _verde = Color(0xFF2E7D32);
  static const Color _naranja = Color(0xFFEF6C00);
  static const Color _rojo = Color(0xFFC62828);

  bool _mantenimientoRealizado = false;

  final List<_ComponenteVehiculo> _componentes = [
    const _ComponenteVehiculo(
      nombre: 'Aceite del motor',
      icono: Icons.opacity_rounded,
      progreso: 0.82,
      estado: 'Próximo cambio',
      color: _naranja,
    ),
    const _ComponenteVehiculo(
      nombre: 'Sistema de frenos',
      icono: Icons.settings_rounded,
      progreso: 0.65,
      estado: 'Buen estado',
      color: _verde,
    ),
    const _ComponenteVehiculo(
      nombre: 'Neumáticos',
      icono: Icons.tire_repair_rounded,
      progreso: 0.48,
      estado: 'Revisar presión',
      color: _naranja,
    ),
    const _ComponenteVehiculo(
      nombre: 'Batería',
      icono: Icons.battery_5_bar_rounded,
      progreso: 0.76,
      estado: 'Buen estado',
      color: _verde,
    ),
  ];

  final List<_RegistroMantenimiento> _historial = [
    const _RegistroMantenimiento(
      titulo: 'Cambio de pastillas de freno',
      fecha: '14 mayo 2026',
      kilometraje: '43 850 km',
      taller: 'Taller Central',
      costo: 320,
      icono: Icons.car_repair_rounded,
    ),
    const _RegistroMantenimiento(
      titulo: 'Cambio de aceite y filtro',
      fecha: '2 marzo 2026',
      kilometraje: '40 500 km',
      taller: 'AutoService Lima',
      costo: 185,
      icono: Icons.opacity_rounded,
    ),
    const _RegistroMantenimiento(
      titulo: 'Alineamiento y balanceo',
      fecha: '18 diciembre 2025',
      kilometraje: '36 100 km',
      taller: 'Neumáticos Express',
      costo: 140,
      icono: Icons.tire_repair_rounded,
    ),
  ];

  double get _gastoTotal {
    return _historial.fold(
      0,
      (double total, _RegistroMantenimiento item) => total + item.costo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        title: const Text(
          'Detalle de Mantenimiento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: _azul,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Más opciones',
            onPressed: _mostrarOpciones,
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehiculoCard(),
            const SizedBox(height: 16),
            _buildResumen(),
            const SizedBox(height: 20),
            _buildTituloSeccion(
              titulo: 'Próximo mantenimiento',
              icono: Icons.event_available_rounded,
            ),
            const SizedBox(height: 10),
            _buildProximoMantenimiento(),
            const SizedBox(height: 22),
            _buildTituloSeccion(
              titulo: 'Estado de componentes',
              icono: Icons.health_and_safety_outlined,
            ),
            const SizedBox(height: 10),
            _buildEstadoComponentes(),
            const SizedBox(height: 22),
            _buildTituloSeccion(
              titulo: 'Historial de mantenimiento',
              icono: Icons.history_rounded,
            ),
            const SizedBox(height: 10),
            _buildHistorial(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildVehiculoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_azul, _azulOscuro],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _azul.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 46,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.marca} ${widget.modelo}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget.placa} · ${widget.anio}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _mantenimientoRealizado ? _verde : _amarillo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _mantenimientoRealizado
                        ? 'Mantenimiento actualizado'
                        : 'Mantenimiento próximo',
                    style: TextStyle(
                      color: _mantenimientoRealizado
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumen() {
    return Row(
      children: [
        Expanded(
          child: _ResumenCard(
            titulo: 'Kilometraje',
            valor: '${widget.kilometraje} km',
            icono: Icons.speed_rounded,
            color: _azul,
          ),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: _ResumenCard(
            titulo: 'Próximo servicio',
            valor: '1 220 km',
            icono: Icons.route_rounded,
            color: _naranja,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _ResumenCard(
            titulo: 'Gasto total',
            valor: 'S/ ${_gastoTotal.toStringAsFixed(0)}',
            icono: Icons.payments_outlined,
            color: _verde,
          ),
        ),
      ],
    );
  }

  Widget _buildProximoMantenimiento() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _mantenimientoRealizado
              ? _verde.withOpacity(0.45)
              : _amarillo.withOpacity(0.75),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (_mantenimientoRealizado ? _verde : _amarillo)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _mantenimientoRealizado
                        ? Icons.check_circle_rounded
                        : Icons.oil_barrel_rounded,
                    color: _mantenimientoRealizado ? _verde : _naranja,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _mantenimientoRealizado
                            ? 'Mantenimiento completado'
                            : 'Cambio de aceite y filtro',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _mantenimientoRealizado
                            ? 'El vehículo se encuentra actualizado.'
                            : 'Servicio preventivo recomendado.',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_mantenimientoRealizado)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _rojo.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PRÓXIMO',
                      style: TextStyle(
                        color: _rojo,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (!_mantenimientoRealizado) ...[
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: _DatoMantenimiento(
                      icono: Icons.calendar_today_outlined,
                      titulo: 'Fecha estimada',
                      valor: '18 julio 2026',
                    ),
                  ),
                  Expanded(
                    child: _DatoMantenimiento(
                      icono: Icons.speed_rounded,
                      titulo: 'Kilometraje',
                      valor: '46 500 km',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(
                    child: _DatoMantenimiento(
                      icono: Icons.storefront_outlined,
                      titulo: 'Taller',
                      valor: 'Por definir',
                    ),
                  ),
                  Expanded(
                    child: _DatoMantenimiento(
                      icono: Icons.payments_outlined,
                      titulo: 'Costo estimado',
                      valor: 'S/ 180',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: 0.82,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(_naranja),
              ),
              const SizedBox(height: 7),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Uso del aceite',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Text(
                    '82%',
                    style: TextStyle(
                      color: _naranja,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reprogramarMantenimiento,
                      icon: const Icon(Icons.edit_calendar_rounded),
                      label: const Text('Reprogramar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _azul,
                        side: const BorderSide(color: _azul),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _marcarComoRealizado,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Realizado'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _amarillo,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoComponentes() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _componentes.length,
        separatorBuilder: (_, __) => const Divider(height: 25),
        itemBuilder: (BuildContext context, int index) {
          final _ComponenteVehiculo componente = _componentes[index];

          return Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: componente.color.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(componente.icono, color: componente.color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            componente.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF263238),
                            ),
                          ),
                        ),
                        Text(
                          componente.estado,
                          style: TextStyle(
                            color: componente.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: componente.progreso,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        componente.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistorial() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 7),
        itemCount: _historial.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (BuildContext context, int index) {
          final _RegistroMantenimiento registro = _historial[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _azul.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(registro.icono, color: _azul),
            ),
            title: Text(
              registro.titulo,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                '${registro.fecha} · ${registro.kilometraje}\n'
                '${registro.taller}',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'S/ ${registro.costo.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: _verde,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Icon(Icons.chevron_right_rounded, color: Colors.black38),
              ],
            ),
            onTap: () => _mostrarDetalleRegistro(registro),
          );
        },
      ),
    );
  }

  Widget _buildTituloSeccion({
    required String titulo,
    required IconData icono,
  }) {
    return Row(
      children: [
        Icon(icono, color: _azul, size: 21),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF263238),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _registrarMantenimiento,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Registrar Mantenimiento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _amarillo,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _marcarComoRealizado() {
    setState(() {
      _mantenimientoRealizado = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mantenimiento marcado como realizado'),
        backgroundColor: _verde,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reprogramarMantenimiento() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 20)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      helpText: 'Seleccionar nueva fecha',
      cancelText: 'Cancelar',
      confirmText: 'Guardar',
    );

    if (fecha == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mantenimiento reprogramado para '
          '${fecha.day}/${fecha.month}/${fecha.year}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _registrarMantenimiento() {
    final TextEditingController servicioController = TextEditingController();
    final TextEditingController costoController = TextEditingController();
    final TextEditingController tallerController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      children: [
                        Icon(Icons.car_repair_rounded, color: _azul),
                        SizedBox(width: 9),
                        Text(
                          'Registrar mantenimiento',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: servicioController,
                      decoration: const InputDecoration(
                        labelText: 'Servicio realizado',
                        prefixIcon: Icon(Icons.build_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el servicio realizado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: tallerController,
                      decoration: const InputDecoration(
                        labelText: 'Taller',
                        prefixIcon: Icon(Icons.storefront_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: costoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Costo',
                        prefixText: 'S/ ',
                        prefixIcon: Icon(Icons.payments_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }

                          final double costo =
                              double.tryParse(costoController.text) ?? 0;

                          setState(() {
                            _historial.insert(
                              0,
                              _RegistroMantenimiento(
                                titulo: servicioController.text.trim(),
                                fecha: 'Hoy',
                                kilometraje: '${widget.kilometraje} km',
                                taller: tallerController.text.trim().isEmpty
                                    ? 'No especificado'
                                    : tallerController.text.trim(),
                                costo: costo,
                                icono: Icons.build_circle_outlined,
                              ),
                            );
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Mantenimiento registrado correctamente',
                              ),
                              backgroundColor: _verde,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _amarillo,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Guardar Mantenimiento',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalleRegistro(_RegistroMantenimiento registro) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 5, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _azul.withOpacity(0.12),
                    child: Icon(registro.icono, color: _azul),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      registro.titulo,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _DetalleFila(
                icono: Icons.calendar_today_outlined,
                titulo: 'Fecha',
                valor: registro.fecha,
              ),
              _DetalleFila(
                icono: Icons.speed_rounded,
                titulo: 'Kilometraje',
                valor: registro.kilometraje,
              ),
              _DetalleFila(
                icono: Icons.storefront_outlined,
                titulo: 'Taller',
                valor: registro.taller,
              ),
              _DetalleFila(
                icono: Icons.payments_outlined,
                titulo: 'Costo',
                valor: 'S/ ${registro.costo.toStringAsFixed(0)}',
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarOpciones() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: _azul),
                title: const Text('Editar datos del vehículo'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications_active_outlined,
                  color: _naranja,
                ),
                title: const Text('Configurar recordatorios'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: _rojo,
                ),
                title: const Text('Exportar historial'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResumenCard extends StatelessWidget {
  const _ResumenCard({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 25),
          const SizedBox(height: 8),
          Text(
            valor,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _DatoMantenimiento extends StatelessWidget {
  const _DatoMantenimiento({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  final IconData icono;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFF1565C0), size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF263238),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetalleFila extends StatelessWidget {
  const _DetalleFila({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  final IconData icono;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF1565C0), size: 22),
          const SizedBox(width: 13),
          Expanded(
            child: Text(titulo, style: const TextStyle(color: Colors.black54)),
          ),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ComponenteVehiculo {
  const _ComponenteVehiculo({
    required this.nombre,
    required this.icono,
    required this.progreso,
    required this.estado,
    required this.color,
  });

  final String nombre;
  final IconData icono;
  final double progreso;
  final String estado;
  final Color color;
}

class _RegistroMantenimiento {
  const _RegistroMantenimiento({
    required this.titulo,
    required this.fecha,
    required this.kilometraje,
    required this.taller,
    required this.costo,
    required this.icono,
  });

  final String titulo;
  final String fecha;
  final String kilometraje;
  final String taller;
  final double costo;
  final IconData icono;
}
