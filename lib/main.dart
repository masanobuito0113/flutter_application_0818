import 'package:flutter/material.dart';
import 'header.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( // themeを追加
        primaryColor: Colors.white, // 全体の共通色を設定
      ),
      home: Scaffold(  
        appBar: Header(),
        body: 
      ),
    );
  }
}