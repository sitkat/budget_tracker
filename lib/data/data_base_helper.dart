import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'budget.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Expense (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            place TEXT,
            category TEXT,
            date TEXT,
            note TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Category (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        await db.insert('Category', {'name': 'Food'});
        await db.insert('Category', {'name': 'Market'});
        await db.insert('Category', {'name': 'Travel'});
        await db.insert('Category', {'name': 'Financial operations'});
        await db.insert('Category', {'name': 'Entertainment'});
        await db.insert('Category', {'name': 'Other'});
      },
    );
  }
}
