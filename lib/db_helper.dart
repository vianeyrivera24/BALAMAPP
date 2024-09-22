import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/carrera.dart';
import 'models/semestre.dart';
import 'models/grupo.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE carreras(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE semestres(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE grupos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT
      )
    ''');

    // Insertar datos iniciales
    await db.insert('carreras', {'nombre': 'ISC'});
    await db.insert('carreras', {'nombre': 'IME'});
    await db.insert('carreras', {'nombre': 'IIN'});
    await db.insert('carreras', {'nombre': 'IGE'});
    await db.insert('carreras', {'nombre': 'Todos'});

    await db.insert('semestres', {'nombre': '1'});
    await db.insert('semestres', {'nombre': '2'});
    await db.insert('semestres', {'nombre': '3'});
    await db.insert('semestres', {'nombre': '4'});
    await db.insert('semestres', {'nombre': '5'});
    await db.insert('semestres', {'nombre': '6'});
    await db.insert('semestres', {'nombre': '7'});
    await db.insert('semestres', {'nombre': '8'});
    await db.insert('semestres', {'nombre': '9'});
    await db.insert('semestres', {'nombre': '10'});
    await db.insert('semestres', {'nombre': '11'});
    await db.insert('semestres', {'nombre': '12'});
    await db.insert('semestres', {'nombre': '13'});
    await db.insert('semestres', {'nombre': '14'});
    await db.insert('semestres', {'nombre': 'Todos'});

    await db.insert('grupos', {'nombre': 'Grupo 1AM'});
    await db.insert('grupos', {'nombre': 'Grupo 1BM'});
    await db.insert('grupos', {'nombre': 'Grupo 2AM'});
    await db.insert('grupos', {'nombre': 'Grupo 2BM'});
    await db.insert('grupos', {'nombre': 'Grupo 1AV'});
    await db.insert('grupos', {'nombre': 'Grupo 1BV'});
    await db.insert('grupos', {'nombre': 'Grupo 2AV'});
    await db.insert('grupos', {'nombre': 'Grupo 2BV'});
  }

  Future<List<Carrera>> getCarreras() async {
    final db = await database;
    var res = await db.query('carreras');
    return res.isNotEmpty ? res.map((c) => Carrera.fromMap(c)).toList() : [];
  }

  Future<List<Semestre>> getSemestres() async {
    final db = await database;
    var res = await db.query('semestres');
    return res.isNotEmpty ? res.map((s) => Semestre.fromMap(s)).toList() : [];
  }

  Future<List<Grupo>> getGrupos() async {
    final db = await database;
    var res = await db.query('grupos');
    return res.isNotEmpty ? res.map((g) => Grupo.fromMap(g)).toList() : [];
  }
}
