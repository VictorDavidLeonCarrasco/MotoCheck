import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/vehiculo.dart';
import '../models/mantenimiento.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'motocheck.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE vehiculos(id INTEGER PRIMARY KEY AUTOINCREMENT, placa TEXT, marca TEXT, modelo TEXT, anio INTEGER, color TEXT)',
    );
    await db.execute(
      'CREATE TABLE mantenimientos(id INTEGER PRIMARY KEY AUTOINCREMENT, vehiculoPlaca TEXT, falla TEXT, fecha TEXT, estado TEXT)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'CREATE TABLE mantenimientos(id INTEGER PRIMARY KEY AUTOINCREMENT, vehiculoPlaca TEXT, falla TEXT, fecha TEXT, estado TEXT)',
      );
    }
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> queryRowCount(String table) async {
    final db = await database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'),
    );
    return result ?? 0;
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String where,
    List<Object?> whereArgs,
  ) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table,
    String where,
    List<Object?> whereArgs,
  ) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // --- MÓDULO VEHÍCULOS ---
  static Future<int> insertVehiculo(Vehiculo vehiculo) async {
    return await instance.insert('vehiculos', vehiculo.toMap());
  }

  static Future<List<Vehiculo>> obtenerVehiculos() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('vehiculos');
    return List.generate(maps.length, (i) => Vehiculo.fromMap(maps[i]));
  }

  static Future<int> updateVehiculo(Vehiculo vehiculo) async {
    return await instance.update(
      'vehiculos',
      vehiculo.toMap(),
      where: 'id = ?',
      whereArgs: [vehiculo.id],
    );
  }

  static Future<int> deleteVehiculo(int id) async {
    return await instance.delete('vehiculos', where: 'id = ?', whereArgs: [id]);
  }

  // --- MÓDULO MANTENIMIENTOS ---
  static Future<int> insertMantenimiento(Mantenimiento mant) async {
    return await instance.insert('mantenimientos', mant.toMap());
  }

  static Future<List<Mantenimiento>> obtenerMantenimientos() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('mantenimientos');
    return List.generate(maps.length, (i) => Mantenimiento.fromMap(maps[i]));
  }

  // --- CONTADORES DEL DASHBOARD ---
  static Future<int> contarVehiculos() async {
    return await instance.queryRowCount('vehiculos');
  }

  static Future<int> contarMantenimientos() async {
    return await instance.queryRowCount('mantenimientos');
  }

  static Future<int> contarPendientes() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM mantenimientos WHERE estado = 'Pendiente'",
          ),
        ) ??
        0;
  }

  static Future<int> contarAtendidos() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(
          await db.rawQuery(
            "SELECT COUNT(*) FROM mantenimientos WHERE estado = 'Atendido'",
          ),
        ) ??
        0;
  }
}
