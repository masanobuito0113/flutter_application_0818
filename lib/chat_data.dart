import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatData {
  final String chatRoomId;
  final String currentUserUid;
  final String partnerUserUid;

  ChatData({
    required this.chatRoomId,
    required this.currentUserUid,
    required this.partnerUserUid,
  });
 final _databaseReference = FirebaseDatabase.instance.reference();


  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return ''; 
    }
  }

Future<void> sendMessage(types.TextMessage message) async {
  try {
    final messageReference = _databaseReference.child('chatRooms').child(chatRoomId).child('chatMessages');
    final newMessageRef = messageReference.push();
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;

    final messageData = {
      'senderUid': currentUserUid,
      'receiverUid': partnerUserUid,
      'text': message.text,
      'timestamp': timestamp,
    };

    await newMessageRef.set(messageData);
  } catch (error) {
    print('メッセージの送信中にエラーが発生しました: $error');
  }
}

void setupMessageListener(Function(Map<String, dynamic>) onMessageReceived) {
  final messageReference = _databaseReference.child('chatRooms').child(chatRoomId).child('chatMessages');
  messageReference.onChildAdded.listen((event) {
    final value = event.snapshot.value;
    if (value != null) {
      final data = Map<String, dynamic>.from(value as Map);
      onMessageReceived(data);
    }
  });
}


  Future<void> saveMessageToLocal(types.TextMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList('chat_messages') ?? [];
    final messageJson = message.toJson();
    messages.add(jsonEncode(messageJson));
    await prefs.setStringList('chat_messages', messages);
  }

  Future<List<String>> loadMessagesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('chat_messages') ?? [];
  }
}
