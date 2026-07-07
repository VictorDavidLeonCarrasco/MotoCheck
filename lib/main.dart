import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Asegúrate de tener este archivo generado por FlutterFire
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  // 1. Aseguramos que el motor visual de Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Encendemos Firebase antes de hacer cualquier otra cosa
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("🔥 Firebase conectado exitosamente a MotoCheck");
  } catch (e) {
    debugPrint("⚠️ Error al conectar Firebase: $e");
  }

  // 3. Arrancamos la aplicación
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
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // Tu pantalla inicial
    );
  }
}
