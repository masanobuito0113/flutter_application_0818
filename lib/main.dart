import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'parts/header.dart';
import 'top.dart'; // トップ画面のインポート
import 'login.dart'; // ログイン画面のインポート
import 'package:firebase_core/firebase_core.dart'; // Firebaseの初期化に必要なパッケージ


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterアプリの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // MyApp クラスを実行
}

class MyApp extends StatelessWidget {
  // ここでログイン状態を確認し、遷移先を決定します
  bool isLoggedIn = false; // ダミーのログイン状態、実際には適切な方法で確認します

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: Header(), // HeaderウィジェットをAppBarとして配置
        body: isLoggedIn ? TopPage() : LoginPage(),
      ),
    ); // ログイン状態によって遷移先を変更
  }
}
