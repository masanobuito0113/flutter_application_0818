import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_0818/Iinvitation.dart';
import 'registar.dart';
import 'top.dart';
import 'Iinvitation.dart';

class InviteCodePage extends StatefulWidget {

  @override
  _InviteCodePageState createState() => _InviteCodePageState();
}

class _InviteCodePageState extends State<InviteCodePage> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  String? chatRoomId;

Future<void> _joinChatRoom() async {
  final chatRoomId = _controller.text;

  if (chatRoomId.isEmpty) {
    setState(() {
      _errorMessage = "招待コードを入力してください";
    });
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  final userId = user?.uid;

  if (userId == null) {
    setState(() {
      _errorMessage = "ログインしていません";
    });
    return;
  }

  try {
    final event = await dbRef.child('chats').child(chatRoomId).once();
    final snapshot = event.snapshot;

    if (snapshot.value != null) {
      // チャットルームIDが有効
      // ユーザーIDをチャットルームの参加者リストに追加する
      await dbRef.child('chats').child(chatRoomId).child('users').child(userId).set(true);
      _redirectToChatRoom(chatRoomId);
    } else {
      // チャットルームIDが無効
      setState(() {
        _errorMessage = "無効な招待コードです";
      });
    }
  } catch (error) {
    setState(() {
      _errorMessage = "エラーが発生しました: $error";
    });
  }
}


  void _redirectToChatRoom(String chatRoomId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TopPage(chatRoomId: chatRoomId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('招待コード入力'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
ElevatedButton(
  onPressed: () async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      // 新しいチャットルームを作成
      DatabaseReference chatRef = dbRef.child('chats').push();
      chatRoomId = chatRef.key;  // ここでチャットルームのIDを取得します

      // 新しいチャットルームIDをユーザーデータに保存（または別の方法で保存）
      await chatRef.set({
        'users': [userId], // ここにチャットルームに参加するユーザーのリストを追加します
      });

      // 新しいチャットルームIDを次の画面に渡す
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvitationPage(chatRoomId: chatRoomId!),
        ),
      );
    }
  },
  child: Text('コードがない方はこちら'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '招待コード',
                  errorText: _errorMessage,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _joinChatRoom,
                child: Text('招待コードを送信'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}