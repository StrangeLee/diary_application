import 'package:diary_application/view/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/*
 * Flutter로 Android는 material 디자인으로 
 * Ios는 cupertino 디자인으로 화면 구성을 할 것이다.
 * 다이어리 앱으로 간단하게 적용해 볼 것이며
 * 일기 추가, 삭제, 편집, 보기(다이얼로그)의 기능만 구현할 것이다.
 */

final materialThemeData = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.blue.shade600),
    primaryColor: Colors.blue,
    secondaryHeaderColor: Colors.blue,
    canvasColor: Colors.blue,
    backgroundColor: Colors.red,
    textTheme: TextTheme().copyWith(body1: TextTheme().body1));

final cupertinoTheme = CupertinoThemeData(
    primaryColor: Colors.blue,
    barBackgroundColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white);

void main() {
  runApp(PlatformApp(
    debugShowCheckedModeBanner: false,
    android: (_) => MaterialAppData(theme: materialThemeData),
    ios: (_) => CupertinoAppData(theme: cupertinoTheme),
    home: MainPage(),
    title: 'Diary Application',
  ));
}
