import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatData {
  final String chatRoomId;
  final String currentUserUid;
  final String partnerUserUid;
  final DatabaseReference _databaseReference;

ChatData({
  required this.chatRoomId,
  required this.currentUserUid,
  required this.partnerUserUid,
})  : assert(partnerUserUid.isNotEmpty, 'Partner UID must not be empty.'),
      _databaseReference = FirebaseDatabase.instance.reference();


  void setupMessageListener(Function(Map<String, dynamic>) onMessageReceived) {
  final messageReference = _databaseReference.child('chatRooms').child(chatRoomId).child('chats');
  messageReference.onChildAdded.listen((event) {
  final value = event.snapshot.value;
  if (value != null) {
    final data = Map<String, dynamic>.from(value as Map);
    onMessageReceived(data);
  }
});

  }

  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return ''; 
    }
  }

Future<void> sendMessage(types.TextMessage message, String senderUid, String receiverUid) async {
  try {
    if (partnerUserUid.isEmpty) {
      throw Exception('パートナーのUIDを取得できませんでした。');
    }

    // 新しいメッセージをFirebaseに送信
    await _databaseReference.child('chatRooms').child(chatRoomId).child('chats').push().set({
      'text': message.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch, 
      'senderUid': senderUid,
      'receiverUid': receiverUid,
    });
  } catch (error) {
    print('メッセージの送信中にエラーが発生しました: $error');
  }
}

 Future<void> saveMessageToLocal(types.TextMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> messages = prefs.getStringList('chat_messages_${chatRoomId}') ?? [];
  final messageJson = message.toJson();
  messages.add(jsonEncode(messageJson));
  await prefs.setStringList('chat_messages_${chatRoomId}', messages);
}

Future<List<String>> loadMessagesFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('chat_messages_${chatRoomId}') ?? [];
}
}
