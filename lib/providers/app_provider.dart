import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AppProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  int cantVehiculos = 0;
  int cantMantenimientos = 0;
  int cantPendientes = 0;
  int cantHistorial = 0;

  AppProvider() {
    cargarContadores();
  }

  Future<void> cargarContadores() async {
    cantVehiculos = await _databaseHelper.contarVehiculos();
    cantMantenimientos = await _databaseHelper.contarMantenimientos();
    cantPendientes = await _databaseHelper.contarPendientes();
    cantHistorial = await _databaseHelper.contarAtendidos();
    notifyListeners();
  }

  void actualizarDatos() {
    cargarContadores();
  }
}
