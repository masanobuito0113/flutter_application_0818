import 'package:flutter/material.dart';
import 'package:flutter_application_0818/schedule.dart';
import 'chat_room.dart';
import 'package:google_fonts/google_fonts.dart';


class TopPage extends StatelessWidget {
  final String? chatRoomId;

  TopPage({this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ChatRoomButton(chatRoomId: chatRoomId), // chatRoomIdをChatRoomButtonに渡します
    );
  }
}

class ChatRoomButton extends StatelessWidget {
  final String? chatRoomId; // ChatRoomButtonでchatRoomIdを宣言します

  const ChatRoomButton({Key? key, this.chatRoomId}) : super(key: key); // コンストラクタでchatRoomIdを受け取ります

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(chatRoomId: chatRoomId ?? ''), // ここでchatRoomIdを渡します
                  ),
                );
              },
              child: Text(
                'Chat',
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              },
              child: Text(
                'Schedule', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // 他のボタンの処理
              },
              child: Text(
                'FlowerPoint', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // 他のボタンの処理
              },
              child: Text(
                'Setting', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


