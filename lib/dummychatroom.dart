import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'chat_data.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;
  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  bool _isDataInitialized = false; 
  final List<types.Message> _messages = [];
  late final types.User _user;
  late final ChatData _chatData;
  String? partnerUserUid;
  late final String userUid; 

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async {
    userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _user = types.User(id: userUid);

    final dbRef = FirebaseDatabase.instance.reference();
    final chatRoomDataSnapshot = await dbRef.child('chatRooms').child(widget.chatRoomId).once();
    print('Raw data: ${chatRoomDataSnapshot.snapshot.value}');

    // 値がMapであるかチェック
    if (chatRoomDataSnapshot.snapshot.value is Map) {
        final chatRoomDataMap = Map<String, dynamic>.from(chatRoomDataSnapshot.snapshot.value as Map);
        final chatRoomValue = chatRoomDataMap.values.first as Map<String, dynamic>;


        if (chatRoomValue.containsKey('owner_uid') && chatRoomValue.containsKey('partner_uid')) {
            if (chatRoomValue['owner_uid'] == userUid) {
                partnerUserUid = chatRoomValue['partner_uid'];
            } else {
                partnerUserUid = chatRoomValue['owner_uid'];
            }
        } else {
            print('チャットルームのデータ構造が正しくありません。');
            return;
        }
    } else {
        print('チャットルームのデータが存在しないか、マップではありません。');
        return;
    }

    if (partnerUserUid == null || partnerUserUid!.isEmpty) {
        print('パートナーのUIDを決定できませんでした。');
        return;
    }

    _chatData = ChatData(
        chatRoomId: widget.chatRoomId,
        currentUserUid: userUid,
        partnerUserUid: partnerUserUid!,
    );

    _chatData.setupMessageListener((messageData) {
        final timestamp = messageData['timestamp'] as int?;
        if (timestamp != null) {
            final senderUid = messageData['senderUid'] as String;
            final author = senderUid == userUid ? _user : types.User(id: senderUid);

            final message = types.TextMessage(
                id: Uuid().v4(),
                author: author,
                text: messageData['text'] ?? '',
                createdAt: timestamp,
            );

            if (mounted) {
                setState(() {
                    _addMessage(message);
                });
            }
        } else {
            print('メッセージのタイムスタンプがnullです。');
        }
    });

    _loadMessages();

    setState(() {
        _isDataInitialized = true;
    });
}


  Future<void> _loadMessages() async {
    if (!_isDataInitialized) {
      return;
    }

    final dbRef = FirebaseDatabase.instance.reference();
    final dataSnapshot = await dbRef.child('chatRooms').child(widget.chatRoomId).child('chats').orderByKey().limitToLast(100).once();

       if (dataSnapshot.snapshot.value != null) {
      final messagesData = Map<String, dynamic>.from(dataSnapshot.snapshot.value as Map);
      messagesData.forEach((key, value) {
        final messageData = value as Map<String, dynamic>;
        final timestamp = messageData['timestamp'] as int;
        final senderUid = messageData['senderUid'] as String;
        
        types.User author;
        if (senderUid == userUid) {
          author = _user;
        } else {
          author = types.User(id: senderUid);
        }

        final message = types.TextMessage(
          id: key,
          author: author,
          text: messageData['text'] ?? '',
          createdAt: timestamp,
        );

        _addMessage(message);
      });
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Chatroom', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: Chat(
          user: _user,
          messages: _messages,
          onSendPressed: _isDataInitialized ? _handleSendPressed : (message) {},
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    if (!_isDataInitialized) {
      print('Data is not initialized yet.');
      return;
    }

    final transformedMessage = message.text;

    final textMessage = types.TextMessage(
      author: _user,
      id: Uuid().v4(),
      text: transformedMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _chatData.sendMessage(textMessage, userUid, partnerUserUid!);

  }
}
