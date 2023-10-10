import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0818/top.dart';
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
  final chatRoomValue = Map<String, dynamic>.from(chatRoomDataSnapshot.snapshot.value as Map);


print('chatRoomValue: $chatRoomValue');
print('chatRoomValue runtime type: ${chatRoomValue.runtimeType}');

if (chatRoomValue != null) {
  bool chatRoomMapFound = false;
  for (var key in chatRoomValue.keys) {
    if (chatRoomValue[key].containsKey('owner_uid') && chatRoomValue[key].containsKey('partner_uid')) {
      chatRoomMapFound = true;
      if (chatRoomValue[key]['owner_uid'] == userUid) {
        partnerUserUid = chatRoomValue[key]['partner_uid'];
      } else {
        partnerUserUid = chatRoomValue[key]['owner_uid'];
      }
      break; // exit loop once we've found the correct chatRoom
    }
  }

  if (!chatRoomMapFound) {
    print('Could not find a chat room map with owner_uid and partner_uid.');
    return;
  }
} else {
  print('Chat room data is null or not a map');
  return;
}
  
  // If we found a valid chatRoomMap, extract the partner UID
//   if (chatRoomMap != null) {
//     if (chatRoomMap['owner_uid'] == userUid) {
//       partnerUserUid = chatRoomMap['partner_uid'];
//     } else {
//       partnerUserUid = chatRoomMap['owner_uid'];
//     }
//   } else {
//     print('Could not find a chat room map with owner_uid and partner_uid.');
//     return;
//   }
// } else {
//   print('Chat room data is null or not a map');
//   return;
// }


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
  return WillPopScope(
    onWillPop: () async {      return true;
      // if (Navigator.canPop(context)) {
      //   Navigator.of(context).pop();
      //   return false;
      // } else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => TopPage()),
      //   );
      //   return false;
      // }
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            // if (Navigator.canPop(context)) {
            //   Navigator.of(context).pop();
            // } else {
            //   Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => TopPage()),
            //     (route) => false, 
            //   );
            // }
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

  // Firebase Functionの接続をカット
  // String transformedMessage = await makeChatGentler(message.text);
  String transformedMessage = message.text;

  final textMessage = types.TextMessage(
    author: _user,
    id: Uuid().v4(),
    text: transformedMessage,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  );
  _chatData.sendMessage(textMessage, _user.id, partnerUserUid!);
  _chatData.saveMessageToLocal(textMessage);
}
}
