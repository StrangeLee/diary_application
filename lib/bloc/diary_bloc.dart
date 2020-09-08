import 'dart:async';

import 'package:diary_application/data/diary.dart';
import 'package:diary_application/db.dart';

class DiaryBloc {
  final _diaryController = StreamController<List<Diary>>.broadcast();
  get diarys => _diaryController.stream;

  DiaryBloc() {
    getDiarys();
  }

  dispose() {
    _diaryController.close();
  }

  getDiarys() async {
    _diaryController.sink.add(await DBHelper().getAllDiarys());
  }

  addDiarys(Diary diary) async {
    await DBHelper().createData(diary);
    getDiarys();
  }

  deleteDiary(int id) async {
    await DBHelper().deleteDiary(id);
  }

  deleteAll() async {
    await DBHelper().deleteAllDiarys();
    getDiarys();
  }
}
