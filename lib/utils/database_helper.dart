import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_database/model/user_model.dart';

class DatabaseHelper {
  // named constructor
  DatabaseHelper.internal();

  // create instance for access DatabaseHelper member.
  static final DatabaseHelper instance = DatabaseHelper.internal();


  factory DatabaseHelper() => instance;

  static const _dbName = "MyDatabase.db";
  static const _dbVersion = 1;

  static const tableUser = "user";
  static const columnId = "id";
  static const columnName = "name";
  static const columnEmail = "email";

  static Database? _database;

  //Getter for access database.
  Future<Database?> get getDatabase async {
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
                             $columnEmail VARCHAR(30) NOT NULL
                            )
    ''');
  }

  Future<List<UserModel>> getUser() async {
    Database? db = await instance.getDatabase;

    var res = await db!.query(tableUser);

    // Convert the list of maps to a list of UserModel objects
    List<UserModel> userList = res.map((userMap) {
      return UserModel(
        id: userMap[columnId] as int,
        name: userMap[columnName] as String,
        email: userMap[columnEmail] as String,
      );
    }).toList();
    return userList;
  }

  Future<int> insert(UserModel user) async {
    Database? db = await instance.getDatabase;

    return await db!.insert(tableUser, user.toJson());
  }

  Future<int> update(UserModel user) async {
    Database? db = await instance.getDatabase;

    return await db!.update(tableUser, user.toJson(),
        where: "$columnId=?", whereArgs: [user.id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.getDatabase;
    // await db!.execute("DELETE FROM $tableUser WHERE $columnId = $id");
    // return await db!.delete(tableUser, where: "$columnId=?", whereArgs: [id]);
    return await db!.rawDelete("DELETE FROM $tableUser WHERE $columnId = $id");
  }

  Future close() async {
    Database? db = await instance.getDatabase;
    return db!.close();
  }
}
