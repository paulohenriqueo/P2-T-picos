import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();
  Database? internal;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper.internal();

  Future<Database?> get database async {
    if (internal != null) return internal;
    internal = await initDatabase();
    return internal;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, sobrenome TEXT, email TEXT, password TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(
    String nome,
    String sobrenome,
    String email,
    String password,
  ) async {
    final db = await database;
    await db!.insert('users', {
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db!.query(
      'users',
      where: "email = ?",
      whereArgs: [email],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db!.query('users');
  }
}
