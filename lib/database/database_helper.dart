<<<<<<< HEAD
import 'dart:async';
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
=======
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
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 8979e7c65d0c5dcdf8bda14187507c68af650858
  }
}
