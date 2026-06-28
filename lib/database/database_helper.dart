import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehiculo.dart';
import '../models/mantenimiento.dart';

class DatabaseHelper {
  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'motocheck.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE vehiculos(id INTEGER PRIMARY KEY AUTOINCREMENT, placa TEXT, marca TEXT, modelo TEXT, anio INTEGER)',
        );
        await db.execute(
          'CREATE TABLE mantenimientos(id INTEGER PRIMARY KEY AUTOINCREMENT, vehiculoPlaca TEXT, falla TEXT, fecha TEXT, estado TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE mantenimientos(id INTEGER PRIMARY KEY AUTOINCREMENT, vehiculoPlaca TEXT, falla TEXT, fecha TEXT, estado TEXT)',
          );
        }
      },
    );
  }

  // --- MÓDULO VEHÍCULOS ---
  static Future<int> insertVehiculo(Vehiculo vehiculo) async {
    final db = await initDB();
    return await db.insert(
      'vehiculos',
      vehiculo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Vehiculo>> obtenerVehiculos() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('vehiculos');
    return List.generate(maps.length, (i) => Vehiculo.fromMap(maps[i]));
  }

  static Future<int> updateVehiculo(Vehiculo vehiculo) async {
    final db = await initDB();
    return await db.update(
      'vehiculos',
      vehiculo.toMap(),
      where: 'id = ?',
      whereArgs: [vehiculo.id],
    );
  }

  static Future<int> deleteVehiculo(int id) async {
    final db = await initDB();
    return await db.delete('vehiculos', where: 'id = ?', whereArgs: [id]);
  }

  // --- MÓDULO MANTENIMIENTOS ---
  static Future<int> insertMantenimiento(Mantenimiento mant) async {
    final db = await initDB();
    return await db.insert(
      'mantenimientos',
      mant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Mantenimiento>> obtenerMantenimientos() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('mantenimientos');
    return List.generate(maps.length, (i) => Mantenimiento.fromMap(maps[i]));
  }

  // --- CONTADORES DEL DASHBOARD ---
  static Future<int> contarVehiculos() async {
    final db = await initDB();
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM vehiculos'),
        ) ??
        0;
  }

  static Future<int> contarMantenimientos() async {
    final db = await initDB();
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM mantenimientos'),
        ) ??
        0;
  }

  static Future<int> contarPendientes() async {
    final db = await initDB();
    return Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM mantenimientos WHERE estado = 'Pendiente'",
          ),
        ) ??
        0;
  }

  static Future<int> contarAtendidos() async {
    final db = await initDB();
    return Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM mantenimientos WHERE estado = 'Atendido'",
          ),
        ) ??
        0;
  }
}
