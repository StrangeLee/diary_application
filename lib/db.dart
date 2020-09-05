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
    var res = await db.rawInsert(
        'INSERT INTO $TableName(title, content, uploadDate) VALUES(?, ?, ?)',
        [diary.title, diary.content, diary.uploadDate]);
    return res;
  }

  //Read
  getDiary(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty
        ? Diary(
            id: res.first['id'],
            title: res.first['title'],
            content: res.first['content'],
            uploadDate: res.first['uploadDate'])
        : Null;
  }

  //Read All
  Future<List<Diary>> getAllDiarys() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Diary> list = res.isNotEmpty
        ? res
            .map((c) => Diary(
                id: c['id'],
                title: c['title'],
                content: c['content'],
                uploadDate: c['uploadDate']))
            .toList()
        : [];

    return list;
  }

  //Delete
  deleteDiary(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDiarys() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
}
