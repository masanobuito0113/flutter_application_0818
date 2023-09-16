import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; 
import 'top.dart';
import 'package:firebase_database/firebase_database.dart';

class InvitationPage extends StatelessWidget {
  final String chatRoomId;

  InvitationPage({required this.chatRoomId});

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: chatRoomId));
    // ユーザーにコピーが成功したことを知らせるためのフィードバックを追加する
  }

  void _launchMailer() async {
    final String email = 'example@example.com'; // これを動的に更新する必要があります
    final String subject = 'メールのタイトル';
    final String body = 'あなたは招待されています！チャットルームIDは$chatRoomIdです。このIDをアプリで使用してチャットルームに参加してください。';
    final String url = 'mailto:$email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ここでユーザーにフィードバックを提供するようなSnackbarやダイアログを追加できます。
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('相手を招待しましょう！'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('このIDをコピーして招待してください'),
              Text(chatRoomId, style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _copyToClipboard, 
                child: Text('IDをコピー'),
              ),
              ElevatedButton(
                onPressed: _launchMailer, 
                child: Text('メーラーを立ち上げる'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TopPage(),
                    ),
                  );
                },
                child: Text('202を使ってみる'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

