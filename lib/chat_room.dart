import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'chat_data.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final List<types.Message> _messages = [];
  late final types.User _user;
  late final ChatData _chatData;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: FirebaseAuth.instance.currentUser?.uid ?? '');

    _chatData = ChatData(
      chatRoomId: widget.chatRoomId, 
      currentUserUid: FirebaseAuth.instance.currentUser?.uid ?? '',
      partnerUserUid: 'partner_uid', 
    );

    _chatData.setupMessageListener((messageData) {
      final timestamp = messageData['timestamp'];
      if (timestamp != null) {
        final message = types.TextMessage(
          id: Uuid().v4(),
          author: _user,
          text: messageData['text'],
          createdAt: int.parse(timestamp.toString()),
        );
        setState(() {
          _addMessage(message);
        });
      } else {
        print('Timestamp is null');
      }
    });

    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messageStrings = await _chatData.loadMessagesFromLocal();
    for (var messageString in messageStrings.reversed) {
      final messageJson = jsonDecode(messageString);
      final message = types.TextMessage.fromJson(messageJson);
      _addMessage(message);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatroom', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Chat(
        user: _user,
        messages: _messages,
        onSendPressed: _handleSendPressed,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      id: Uuid().v4(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _chatData.sendMessage(textMessage);

    _chatData.saveMessageToLocal(textMessage);
  }
}
