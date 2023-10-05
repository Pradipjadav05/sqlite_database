import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // named constructor
  DatabaseHelper.internal();

  // create instance for access DatabaseHelper member.
  static final DatabaseHelper instance = DatabaseHelper.internal();

  static const _dbName = "MyDatabase.db";
  static const _dbVersion = 1;

  static const tableUser = "user";
  static const columnId = "id";
  static const columnName = "name";
  static const columnEmail = "email";

  static late Database _database;

  //Getter for access database.
  Future<Database> get getDatabase async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Create or initialize database.
  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUser ($columnId INTEGER PRIMARY KEY, 
                             $columnName TEXT NOT NULL,
                             $columnEmail VARCHAR(25) NOT NULL
                            )
    ''');
  }

  Future<int> insert(Map<String, dynamic> data) async {
    Database db = await instance.getDatabase;

    return await db.insert(tableUser, data);
  }
}
