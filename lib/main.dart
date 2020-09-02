import 'package:diary_application/main_page.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(
    PlatformApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
    title: 'Basket Timer',
  ));
}