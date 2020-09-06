import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:diary_application/data/diary.dart';
import 'package:diary_application/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:toast/toast.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    var diarys = DBHelper().getAllDiarys();

    diarys.then((value) => value.forEach((element) {
          print(element.title);
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PlatformScaffold(
        iosContentPadding: true,
        iosContentBottomPadding: true,
        material: (context, platform) => MaterialScaffoldData(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context),
            child: Icon(Icons.add),
          ),
        ),
        cupertino: (context, platform) => CupertinoPageScaffoldData(
          resizeToAvoidBottomInset: false,
        ),
        appBar: PlatformAppBar(
          title: PlatformText('Diary App'),
          cupertino: (context, platform) => CupertinoNavigationBarData(
              // ios NavigatonBar Button
              transitionBetweenRoutes: false,
              trailing: PlatformButton(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () => _showAddDialog(context),
              )),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: PlatformText(
          '오늘 하루는 어땠나요?',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        child: FutureBuilder(
          future: DBHelper().getAllDiarys(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data[index];
                  return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        DBHelper().deleteDiary(item.id);
                        setState(() {});
                      },
                      child: _diaryListItem(item));
                },
              );
            } else {
              return Center(
                child: PlatformCircularProgressIndicator(),
              );
            }
          },
        ),
        alignment: Alignment.center,
      )
    ]);
  }

  Widget _diaryListItem(Diary diary) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlatformText(
                    diary.title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  PlatformText(
                    diary.uploadDate,
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    var titleTextController = TextEditingController();
    var contentTextController = TextEditingController();

    var maxLines = 10;

    showPlatformDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: maxLines * 40.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: PlatformText(
                          '일기 저장',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: PlatformTextField(
                          controller: titleTextController,
                          material: (context, platform) =>
                              MaterialTextFieldData(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      hintText: '제목')),
                          cupertino: (context, platform) =>
                              CupertinoTextFieldData(placeholder: '제목'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: PlatformTextField(
                          controller: contentTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: PlatformButton(
                          color: const Color(0xFF1BC0C5),
                          child: PlatformText(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (contentTextController.text == '' ||
                                titleTextController.text == '') {
                              Toast.show('입력하지 않은 항목이 있습니다.', context);
                            } else {
                              writeDiary(titleTextController.text,
                                  contentTextController.text);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void writeDiary(String title, String contnent) {
    var now = DateTime.now();
    String nowDate = DateFormat('yyyy-MM-dd').format(now);

    Diary diary = Diary(title: title, content: contnent, uploadDate: nowDate);
    DBHelper().createData(diary);
    setState(() {});
  }
}
