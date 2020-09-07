import 'dart:io';

import 'package:diary_application/data/diary.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String TableName = 'diary';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Diary.db');

    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $TableName(id INTEGER PRIMARY KEY, title TEXT, content TEXT, uploadDate TEXT)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(Diary diary) async {
    final db = await database;
    var res = await db.insert(TableName, diary.toJson());
    return res;
  }

  //Read
  getDiary(int id) async {
    final db = await database;
    var res = await db.query(TableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Diary.fromJson(res.first) : Null;
  }

  //Read All
  Future<List<Diary>> getAllDiarys() async {
    final db = await database;
    var res = await db.query(TableName);
    List<Diary> list =
        res.isNotEmpty ? res.map((c) => Diary.fromJson(c)).toList() : [];

    return list;
  }

  updateDiary(Diary diary) async {
    final db = await database;
    var res = db.update(TableName, diary.toJson(),
        where: 'id = ?', whereArgs: [diary.id]);
    return res;
  }

  //Delete
  deleteDiary(int id) async {
    final db = await database;
    var res = db.delete(TableName, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  //Delete All
  deleteAllDiarys() async {
    final db = await database;
    db.delete(TableName);
  }
}
