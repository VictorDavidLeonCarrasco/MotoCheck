import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/login_screen.dart';
import '../vehiculos/vehiculos_screen.dart';
import '../mantenimientos/mantenimientos_screen.dart';
import '../../providers/app_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  final String rol;
  const HomeScreen({super.key, required this.rol});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _cambiarTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      HomeContent(onTabChange: _cambiarTab, rol: widget.rol),
      const VehiculosScreen(),
      const MantenimientosScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: false, // Alineación a la izquierda
        title: Row(
          children: [
            Image.asset(
              "lib/Assets/Motos.png",
              height: 35,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.motorcycle, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'MotoCheck',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1565C0)),
              accountName: const Text(
                'Usuario MotoCheck',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text('Perfil activo: ${widget.rol}'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF1565C0)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Panel Principal'),
              onTap: () {
                Navigator.pop(context);
                _cambiarTab(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Gestión de Vehículos'),
              onTap: () {
                Navigator.pop(context);
                _cambiarTab(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Taller y Mantenimiento'),
              onTap: () {
                Navigator.pop(context);
                _cambiarTab(2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: pantallas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        onTap: _cambiarTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Vehículos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Mantenimiento",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Function(int) onTabChange;
  final String rol;

  const HomeContent({super.key, required this.onTabChange, required this.rol});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // --- SLIDER MODERNO Y ELEGANTE ---
              CarouselSlider(
                options: CarouselOptions(
                  height: 160.0,
                  autoPlay: true, // Animación automática
                  enlargeCenterPage: true, // Efecto visual 3D
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.85,
                ),
                items: [
                  _buildBanner("Bienvenido a MotoCheck", "Perfil: $rol", const [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ]),
                  _buildBanner(
                    "Mantenimiento Preventivo",
                    "Revisa los pendientes urgentes hoy.",
                    const [Color(0xFFE65100), Color(0xFFFF9800)],
                  ),
                  _buildBanner(
                    "Historial de Taller",
                    "Mantén tus registros al día.",
                    const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- TARJETAS DEL DASHBOARD ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            Icons.directions_car,
                            "Vehículos",
                            "${provider.cantVehiculos}",
                            Colors.blue,
                            isDark,
                            () => onTabChange(1),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCard(
                            Icons.build,
                            "Servicios",
                            "${provider.cantMantenimientos}",
                            Colors.orange,
                            isDark,
                            () => onTabChange(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            Icons.history,
                            "Historial",
                            "${provider.cantHistorial}",
                            Colors.green,
                            isDark,
                            () => onTabChange(2),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildCard(
                            Icons.warning_amber_rounded,
                            "Pendientes",
                            "${provider.cantPendientes}",
                            Colors.redAccent,
                            isDark,
                            () => onTabChange(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner(String titulo, String subtitulo, List<Color> colores) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colores[0].withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitulo,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    IconData icon,
    String titulo,
    String cantidad,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 35),
            ),
            const SizedBox(height: 10),
            Text(
              cantidad,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              titulo,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
