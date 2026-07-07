import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehiculo.dart';
import '../models/mantenimiento.dart';

class DatabaseHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==========================================
  // --- MÓDULO VEHÍCULOS (NUBE) ---
  // ==========================================
  static Future<void> insertVehiculo(Vehiculo vehiculo) async {
    if (vehiculo.id == null) {
      await _db.collection('vehiculos').add(vehiculo.toMap());
    } else {
      await _db
          .collection('vehiculos')
          .doc(vehiculo.id)
          .update(vehiculo.toMap());
    }
  }

  static Future<List<Vehiculo>> obtenerVehiculos() async {
    final snapshot = await _db.collection('vehiculos').get();
    // Solucionado: Se eliminó el "as Map<String, dynamic>" innecesario
    return snapshot.docs
        .map((doc) => Vehiculo.fromMap(doc.data(), doc.id))
        .toList();
  }

  static Future<void> updateVehiculo(Vehiculo vehiculo) async {
    if (vehiculo.id != null) {
      await _db
          .collection('vehiculos')
          .doc(vehiculo.id)
          .update(vehiculo.toMap());
    }
  }

  static Future<void> deleteVehiculo(String id) async {
    await _db.collection('vehiculos').doc(id).delete();
  }

  // ==========================================
  // --- MÓDULO MANTENIMIENTOS (NUBE) ---
  // ==========================================
  static Future<void> insertMantenimiento(Mantenimiento mant) async {
    if (mant.id == null) {
      await _db.collection('mantenimientos').add(mant.toMap());
    } else {
      await _db.collection('mantenimientos').doc(mant.id).update(mant.toMap());
    }
  }

  static Future<List<Mantenimiento>> obtenerMantenimientos() async {
    final snapshot = await _db.collection('mantenimientos').get();
    // Solucionado: Se eliminó el "as Map<String, dynamic>" innecesario
    return snapshot.docs
        .map((doc) => Mantenimiento.fromMap(doc.data(), doc.id))
        .toList();
  }

  static Future<void> deleteMantenimiento(String id) async {
    await _db.collection('mantenimientos').doc(id).delete();
  }

  // ==========================================
  // --- CONTADORES PARA EL DASHBOARD ---
  // ==========================================
  static Future<int> contarVehiculos() async {
    final snapshot = await _db.collection('vehiculos').count().get();
    return snapshot.count ?? 0;
  }

  static Future<int> contarMantenimientos() async {
    final snapshot = await _db.collection('mantenimientos').count().get();
    return snapshot.count ?? 0;
  }

  static Future<int> contarPendientes() async {
    final snapshot = await _db
        .collection('mantenimientos')
        .where('estado', isEqualTo: 'Pendiente')
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  static Future<int> contarAtendidos() async {
    final atendidos = await _db
        .collection('mantenimientos')
        .where('estado', isEqualTo: 'Atendido')
        .count()
        .get();
    final finalizados = await _db
        .collection('mantenimientos')
        .where('estado', isEqualTo: 'Finalizado')
        .count()
        .get();

    return (atendidos.count ?? 0) + (finalizados.count ?? 0);
  }
}
