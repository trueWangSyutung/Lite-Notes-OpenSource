import 'package:litenotes/empty/image.dart';
import 'package:litenotes/empty/note.dart';
import 'package:litenotes/empty/number.dart';
import 'package:litenotes/pages/NotesList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ImageDatabaseHelper {
  static final _databaseName = "images.db";
  static final _databaseVersion = 1;
  static final DATEBASE_TABLE = 'image';
  static final DATEBASE_ID = 'id';
  static final DATEBASE_TEXT = 'url';

  ImageDatabaseHelper._privateConstructor();
  static final ImageDatabaseHelper instance =
      ImageDatabaseHelper._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
           CREATE TABLE $DATEBASE_TABLE ( 
             $DATEBASE_ID INTEGER NOT NULL , 
             $DATEBASE_TEXT TEXT NOT NULL
           ) 
           ''');
  }

  Future<int> insert(Images note) async {
    Database db = await instance.database;
    print(note.toMap());
    var res = 0;
    if (note.id == null || (note.url == null)) {
    } else {
      res = await db.insert(DATEBASE_TABLE, note.toMap());
    }
    return res;
  }

  Future<int> update(Images note) async {
    Database db = await instance.database;
    String sql =
        "UPDATE $DATEBASE_TABLE SET  and $DATEBASE_TEXT = \'${note.url}\' WHERE $DATEBASE_ID = \'${note.id}\'";

    print(sql);
    return await db.update(DATEBASE_TABLE, note.toUpdateMap(),
        where: "id = ?", whereArgs: [note.id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(int id) async {
    Database db = await instance.database;
    var res = await db
        .query(DATEBASE_TABLE, where: '$DATEBASE_ID = ?', whereArgs: [id]);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryRow(int id) async {
    Database db = await instance.database;
    var res = await db
        .query(DATEBASE_TABLE, where: '$DATEBASE_ID = ?', whereArgs: [id]);
    return res;
  }

  Future<int> delete(int id, String path) async {
    Database db = await instance.database;
    return await db.delete(DATEBASE_TABLE,
        where: '$DATEBASE_ID = ? and $DATEBASE_TEXT = ?',
        whereArgs: [id, path]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $DATEBASE_TABLE");
  }
}
