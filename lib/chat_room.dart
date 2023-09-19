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
  final userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  _user = types.User(id: userUid);

  final dbRef = FirebaseDatabase.instance.reference();
  final chatRoomDataSnapshot = await dbRef.child('chatRooms').child(widget.chatRoomId).once();
final chatRoomValue = chatRoomDataSnapshot.snapshot.value;

print('chatRoomValue: $chatRoomValue');
print('chatRoomValue runtime type: ${chatRoomValue.runtimeType}');

if (chatRoomValue != null && chatRoomValue is Map) {
  final chatRoomMap = Map<String, dynamic>.from(chatRoomValue.values.first as Map);

  if (chatRoomMap['owner_uid'] == userUid) {
    partnerUserUid = chatRoomMap['partner_uid'];
  } else {
    partnerUserUid = chatRoomMap['owner_uid'];
  }
} else {
  print('Chat room data is null or not a map');
  return;
}




if (partnerUserUid == null || partnerUserUid!.isEmpty) {
   print('Could not find a partner UID. chatRoomValue was: $chatRoomValue');
   return;
}

  _chatData = ChatData(
    chatRoomId: widget.chatRoomId,
    currentUserUid: userUid,
    partnerUserUid: partnerUserUid!,
  );

print('Chat room value: $chatRoomValue');
print('Partner UID: $partnerUserUid');

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
    print('Timestamp is null');
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
        onSendPressed: _isDataInitialized ? _handleSendPressed : (message) {},
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    if (!_isDataInitialized) {
      print('Data is not initialized yet.');
      return;
    }

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
