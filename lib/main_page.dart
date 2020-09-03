import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      iosContentBottomPadding: true,
      android: (context) => MaterialScaffoldData(
        // android FAB
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
      appBar: PlatformAppBar(
        title: PlatformText('Diary App'),
        ios: (context) => CupertinoNavigationBarData(
            // ios NavigatonBar Button
            transitionBetweenRoutes: false,
            trailing: PlatformButton(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {},
            )),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: PlatformText(
          '오늘 하루는 어땠나요?',
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            _diaryListItem(),
            _diaryListItem(),
            _diaryListItem(),
          ],
        ),
        alignment: Alignment.center,
      )
    ]);
  }

  Widget _diaryListItem() {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlatformText(
                    'Title',
                  ),
                  PlatformText(
                    'MM/dd',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
