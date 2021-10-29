import 'package:litenotes/empty/note.dart';
import 'package:litenotes/empty/number.dart';
import 'package:litenotes/pages/NotesList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final DATEBASE_TABLE = 'notes';
  static final DATEBASE_ID = 'id';
  static final DATEBASE_DATE = 'date';
  static final DATEBASE_TITLE = 'title';
  static final DATEBASE_TEXT = 'text';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
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
             $DATEBASE_ID INTEGER PRIMARY KEY AUTOINCREMENT, 
             $DATEBASE_TITLE TEXT NOT NULL,
            $DATEBASE_TEXT TEXT NOT NULL,
             $DATEBASE_DATE TEXT NOT NULL
           ) 
           ''');

    await db.insert(
        DATEBASE_TABLE, Note(1001, "Welcome", "dfsdfdf", "2021-04-09").toMap());
  }

  Future<int> insert(Note note) async {
    Database db = await instance.database;
    print(note.toMap());
    var res = 0;
    if (note.id == null ||
        (note.text == null && note.title == null && note.date == null)) {
    } else {
      res = await db.insert(DATEBASE_TABLE, note.toMap());
    }
    return res;
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    String sql =
        "UPDATE $DATEBASE_TABLE SET $DATEBASE_TITLE = \'${note.title}\' and $DATEBASE_TEXT = \'${note.text}\' WHERE $DATEBASE_ID = \'${note.id}\'";

    print(sql);
    return await db.update(DATEBASE_TABLE, note.toUpdateMap(),
        where: "id = ?", whereArgs: [note.id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(DATEBASE_TABLE);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryRow(int id) async {
    Database db = await instance.database;
    var res = await db
        .query(DATEBASE_TABLE, where: '$DATEBASE_ID = ?', whereArgs: [id]);
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(DATEBASE_TABLE, where: '$DATEBASE_ID = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $DATEBASE_TABLE");
  }
}
