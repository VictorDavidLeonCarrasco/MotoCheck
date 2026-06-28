import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AppProvider with ChangeNotifier {
  int cantVehiculos = 0;
  int cantMantenimientos = 0;
  int cantPendientes = 0;
  int cantHistorial = 0;

  AppProvider() {
    cargarContadores();
  }

  Future<void> cargarContadores() async {
    cantVehiculos = await DatabaseHelper.contarVehiculos();
    cantMantenimientos = await DatabaseHelper.contarMantenimientos();
    cantPendientes = await DatabaseHelper.contarPendientes();
    cantHistorial = await DatabaseHelper.contarAtendidos();
    notifyListeners();
  }

  void actualizarDatos() {
    cargarContadores();
  }
}
