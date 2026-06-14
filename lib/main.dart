import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MotoCheckApp());
}

class MotoCheckApp extends StatelessWidget {
  const MotoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: '/login',
    );
  }
}
