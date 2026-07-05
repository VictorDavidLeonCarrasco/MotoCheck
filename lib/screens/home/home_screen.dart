import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
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
  int _currentIndex = 0;

  // --- LÓGICA DE NIVELES DE USUARIO ---
  // Determinamos si el usuario tiene permisos de Taller
  bool get esPersonalTaller =>
      widget.rol == 'Taller mecánico' || widget.rol == 'Administrador de flota';

  // Construimos las pantallas dinámicamente. Si no es personal, solo carga 2.
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
        return 'Vehículos';
      case 2:
        return 'Mantenimiento';
      default:
        return 'MotoCheck';
    }
  }

  Future<void> _cerrarSesion() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas cerrar tu sesión de MotoCheck?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Cerrar sesión'),
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
        backgroundColor: _azulPrincipal,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'lib/Assets/Motos.png',
              width: 35,
              height: 35,
              fit: BoxFit.contain,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                    return const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.white,
                    );
                  },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _tituloActual,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pantallas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _azulPrincipal,
        unselectedItemColor: Colors.grey,
        onTap: _cambiarTab,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_rounded),
            label: 'Vehículos',
          ),
          // Ocultamos el botón inferior si no es personal autorizado
          if (esPersonalTaller)
            const BottomNavigationBarItem(
              icon: Icon(Icons.build_rounded),
              label: 'Mantenimiento',
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: _azulPrincipal),
              accountName: const Text(
                'Usuario MotoCheck',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text('Perfil activo: ${widget.rol}'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: _azulPrincipal,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                  // Ocultamos la opción del menú si no es personal autorizado
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
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.onTabChange,
    required this.rol,
    required this.esPersonalTaller, // Requiere el valor booleano
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
          onRefresh: provider.cargarContadores,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 160,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.86,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
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
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _DashboardCard(
                              icono: Icons.directions_car_rounded,
                              titulo: 'Vehículos',
                              cantidad: provider.cantVehiculos,
                              color: Colors.blue,
                              modoOscuro: modoOscuro,
                              onTap: () {
                                onTabChange(1);
                              },
                            ),
                          ),
                          // Bloqueo dinámico para ocultar servicios si es conductor
                          if (esPersonalTaller) ...[
                            const SizedBox(width: 14),
                            Expanded(
                              child: _DashboardCard(
                                icono: Icons.build_rounded,
                                titulo: 'Servicios',
                                cantidad: provider.cantMantenimientos,
                                color: Colors.orange,
                                modoOscuro: modoOscuro,
                                onTap: () {
                                  onTabChange(2);
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Bloqueo dinámico para ocultar historial y pendientes
                      if (esPersonalTaller) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _DashboardCard(
                                icono: Icons.history_rounded,
                                titulo: 'Historial',
                                cantidad: provider.cantHistorial,
                                color: Colors.green,
                                modoOscuro: modoOscuro,
                                onTap: () {
                                  onTabChange(2);
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _DashboardCard(
                                icono: Icons.warning_amber_rounded,
                                titulo: 'Pendientes',
                                cantidad: provider.cantPendientes,
                                color: Colors.redAccent,
                                modoOscuro: modoOscuro,
                                onTap: () {
                                  onTabChange(2);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
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
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colores.first.withValues(alpha: 0.35),
            blurRadius: 11,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 15),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitulo,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: modoOscuro ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: modoOscuro ? 0.30 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, color: color, size: 32),
            ),
            const SizedBox(height: 9),
            Text(
              cantidad.toString(),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            Text(
              titulo,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
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

    return ListTile(
      selected: seleccionado,
      selectedColor: azul,
      selectedTileColor: azul.withValues(alpha: 0.09),
      leading: Icon(icono),
      title: Text(
        titulo,
        style: TextStyle(
          fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
