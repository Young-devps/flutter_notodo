import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../models/nodo_item.dart';


class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = "notodoTbl";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDateCreated = "dateCreated";

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
    String path = join(documentDirectory.path, "notodo_db.db"); //home://directory/files/main.db

    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }



  /*
  *   id | itemName | datecreated
  *   ------------------------
  *    1 | Paulo    | 12/12/2212
  *    2 | James    | 01/89/3255
  * */
  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDateCreated TEXT)"
    );
  }

  //CRUD -- CREATE, READ, UPDATE, DELETE

  //Insertion
  Future<int> saveItem(NodoItem item) async{
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  //Get user
  Future<List> getItems() async{
    var dbClient = await db;
    var results = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnDateCreated ASC"); //ASC
    return results.toList();
  }

  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<NodoItem> getItem(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if (result.length == 0) return null;
    return new NodoItem.fromMap(result.first);
  }

  //Delete users
  Future<int> deleteItem(int id) async{
    var dbClient = await db;
    return await dbClient.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  //Update users
  Future<int> updatItem(NodoItem item) async{
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(), where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future closeDb() async{
    var dbClient = await db;
    return  dbClient.close();
  }
}