import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../faq/faq_screen.dart';
import '../login/login_screen.dart';
import '../mantenimientos/mantenimientos_screen.dart';
import '../vehiculos/vehiculos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.rol});

  final String rol;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _azulPrincipal = Color(0xFF1565C0);
  static const Color _azulOscuro = Color(0xFF0D47A1);
  int _currentIndex = 0;

  // --- LÓGICA DE NIVELES DE USUARIO ---
  bool get esPersonalTaller =>
      widget.rol == 'Taller mecánico' || widget.rol == 'Administrador de flota';

  List<Widget> get _pantallas => [
    HomeContent(
      rol: widget.rol,
      onTabChange: _cambiarTab,
      esPersonalTaller: esPersonalTaller,
    ),
    const VehiculosScreen(),
    if (esPersonalTaller) const MantenimientosScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _actualizarContadores();
    });
  }

  Future<void> _actualizarContadores() async {
    try {
      await context.read<AppProvider>().cargarContadores();
    } catch (error) {
      debugPrint('No se pudieron actualizar los contadores: $error');
    }
  }

  void _cambiarTab(int index) {
    if (index < 0 || index >= _pantallas.length) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  String get _tituloActual {
    switch (_currentIndex) {
      case 1:
        return 'Mis Vehículos';
      case 2:
        return 'Centro de Mantenimiento';
      default:
        return 'Dashboard';
    }
  }

  Future<void> _cerrarSesion() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Cerrar sesión'),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que deseas salir de MotoCheck?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_azulPrincipal, _azulOscuro],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'lib/Assets/Motos.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.directions_car_filled_rounded,
                    color: Colors.white,
                    size: 28,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _tituloActual,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pantallas),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: _azulPrincipal,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            onTap: _cambiarTab,
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.dashboard_rounded, size: 26),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.dashboard_rounded, size: 28),
                ),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.directions_car_rounded, size: 26),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(Icons.directions_car_rounded, size: 28),
                ),
                label: 'Vehículos',
              ),
              if (esPersonalTaller)
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.build_rounded, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.build_rounded, size: 28),
                  ),
                  label: 'Taller',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Cabecera Premium
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 30,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_azulPrincipal, _azulOscuro],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 45,
                      color: _azulPrincipal,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Usuario MotoCheck',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.rol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              children: [
                _DrawerOption(
                  icono: Icons.dashboard_rounded,
                  titulo: 'Panel principal',
                  seleccionado: _currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    _cambiarTab(0);
                  },
                ),
                _DrawerOption(
                  icono: Icons.directions_car_rounded,
                  titulo: 'Gestión de vehículos',
                  seleccionado: _currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    _cambiarTab(1);
                  },
                ),
                if (esPersonalTaller)
                  _DrawerOption(
                    icono: Icons.build_circle_outlined,
                    titulo: 'Taller y mantenimiento',
                    seleccionado: _currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      _cambiarTab(2);
                    },
                  ),
                const SizedBox(height: 20),
                const Divider(indent: 20, endIndent: 20),
                const SizedBox(height: 10),
                _DrawerOption(
                  icono: Icons.help_outline_rounded,
                  titulo: 'Preguntas Frecuentes',
                  seleccionado: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const FAQScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Colors.red),
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _cerrarSesion();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.onTabChange,
    required this.rol,
    required this.esPersonalTaller,
  });

  final ValueChanged<int> onTabChange;
  final String rol;
  final bool esPersonalTaller;

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider provider, Widget? child) {
        return RefreshIndicator(
          color: const Color(0xFF1565C0),
          onRefresh: provider.cargarContadores,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 5,
                  ),
                  child: Text(
                    "Resumen General",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: modoOscuro ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.88,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 1000,
                    ),
                  ),
                  items: [
                    _buildBanner(
                      titulo: 'Bienvenido a MotoCheck',
                      subtitulo: 'Perfil activo: $rol',
                      icono: Icons.verified_user_rounded,
                      colores: const [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    ),
                    _buildBanner(
                      titulo: 'Mantenimiento preventivo',
                      subtitulo: 'Revisa los servicios pendientes.',
                      icono: Icons.build_circle_rounded,
                      colores: const [Color(0xFFE65100), Color(0xFFFF9800)],
                    ),
                    _buildBanner(
                      titulo: 'Historial del taller',
                      subtitulo: 'Mantén tus registros al día.',
                      icono: Icons.history_rounded,
                      colores: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _InteractiveDashboardCard(
                              icono: Icons.directions_car_rounded,
                              titulo: 'Vehículos',
                              cantidad: provider.cantVehiculos,
                              color: Colors.blue,
                              modoOscuro: modoOscuro,
                              onTap: () => onTabChange(1),
                            ),
                          ),
                          if (esPersonalTaller) ...[
                            const SizedBox(width: 18),
                            Expanded(
                              child: _InteractiveDashboardCard(
                                icono: Icons.build_rounded,
                                titulo: 'Servicios',
                                cantidad: provider.cantMantenimientos,
                                color: Colors.orange,
                                modoOscuro: modoOscuro,
                                onTap: () => onTabChange(2),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (esPersonalTaller) ...[
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _InteractiveDashboardCard(
                                icono: Icons.history_rounded,
                                titulo: 'Historial',
                                cantidad: provider.cantHistorial,
                                color: Colors.green,
                                modoOscuro: modoOscuro,
                                onTap: () => onTabChange(2),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _InteractiveDashboardCard(
                                icono: Icons.warning_amber_rounded,
                                titulo: 'Pendientes',
                                cantidad: provider.cantPendientes,
                                color: Colors.redAccent,
                                modoOscuro: modoOscuro,
                                onTap: () => onTabChange(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner({
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required List<Color> colores,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colores.last.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icono, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitulo,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- NUEVA TARJETA INTERACTIVA CON ANIMACIÓN ---
class _InteractiveDashboardCard extends StatefulWidget {
  const _InteractiveDashboardCard({
    required this.icono,
    required this.titulo,
    required this.cantidad,
    required this.color,
    required this.modoOscuro,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final int cantidad;
  final Color color;
  final bool modoOscuro;
  final VoidCallback onTap;

  @override
  State<_InteractiveDashboardCard> createState() =>
      _InteractiveDashboardCardState();
}

class _InteractiveDashboardCardState extends State<_InteractiveDashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed
            ? 0.95
            : 1.0, // Efecto resorte de compresión interactivo
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: widget.modoOscuro ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: widget.modoOscuro ? 0.15 : 0.12,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(widget.icono, color: widget.color, size: 34),
              ),
              const SizedBox(height: 12),
              Text(
                widget.cantidad.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                widget.titulo,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerOption extends StatelessWidget {
  const _DrawerOption({
    required this.icono,
    required this.titulo,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color azul = Color(0xFF1565C0);

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        selected: seleccionado,
        selectedColor: azul,
        selectedTileColor: azul.withValues(alpha: 0.1),
        leading: Icon(icono, size: 26),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
