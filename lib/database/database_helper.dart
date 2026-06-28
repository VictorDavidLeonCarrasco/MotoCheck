import 'dart:async';
import 'package:control_de_mototaxis_o_taxis/models/mantenimiento.dart';
import 'package:control_de_mototaxis_o_taxis/models/vehiculo.dart';
import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'moto_check.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        value TEXT
      )
    ''');
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

  Future<int> contarVehiculos() async {
    return await queryRowCount('items');
  }

  static Future<void> insertMantenimiento(Mantenimiento mant) async {}

  static Future<void> insertVehiculo(Vehiculo v) async {}

  static Future<void> updateVehiculo(Vehiculo v) async {}

  static Future<List<Mantenimiento>> obtenerMantenimientos() async {
    return [];
  }

  Future<int> contarMantenimientos() async {
    return 0;
  }

  Future<int> contarPendientes() async {
    return 0;
  }

  Future<int> contarAtendidos() async {
    return 0;
  }
}
