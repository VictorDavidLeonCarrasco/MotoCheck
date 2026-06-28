import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/splash/splash_screen.dart';
import 'providers/app_provider.dart';

// Función para escuchar notificaciones cuando la app está en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Mensaje recibido en segundo plano: ${message.messageId}");
}

void main() async {
  // Aseguramos que los widgets estén inicializados antes de arrancar Firebase
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint(
      "Firebase aún no está configurado. Configura google-services.json: $e",
    );
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const MotoCheckApp(),
    ),
  );
}

class MotoCheckApp extends StatelessWidget {
  const MotoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoCheck',
      debugShowCheckedModeBanner: false,
      // --- TEMA CLARO ---
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      // --- TEMA OSCURO ELEGANTE ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0D47A1), // Azul más profundo
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ), // Fondo oscuro estándar
        cardColor: const Color(0xFF1E1E1E), // Tarjetas ligeramente más claras
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Cambia automáticamente según el teléfono
      home: const SplashScreen(),
    );
  }
}
