import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../models/user.dart';


class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  static Database _db;

  Future<Database> get db async{
    if (_db != null){
      return _db;
    }

    _db = await initDB();

    return _db;
  }

  DatabaseHelper.internal();

  initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db"); //home://directory/files/main.db

    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }



  /*
  *   id | username | password
  *   ------------------------
  *    1 | Paulo    | ******
  *    2 | James    | ******
  * */
  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)"
    );
  }

  //CRUD -- CREATE, READ, UPDATE, DELETE

  //Insertion
  Future<int> saveUser(User user) async{
    var dbClient = await db;
    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  //Get user
  Future<List> getAllUsers() async{
    var dbClient = await db;
    var results = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return results.toList();
  }

  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

  Future<User> getUser(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
    if (result.length == 0) return null;
    return new User.fromMap(result.first);
  }

  //Delete users
  Future<int> deleteUser(int id) async{
    var dbClient = await db;
    return await dbClient.delete(tableUser, where: "$columnId = ?", whereArgs: [id]);
  }

  //Update users
  Future<int> updateUser(User user) async{
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
  }

  Future closeDb() async{
    var dbClient = await db;
    return  dbClient.close();
  }
}