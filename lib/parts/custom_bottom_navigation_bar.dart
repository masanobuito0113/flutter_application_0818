import 'package:flutter/material.dart';
import 'package:flutter_application_0818/chat_room.dart';
import 'package:flutter_application_0818/schedule.dart';
import 'package:flutter_application_0818/flowerPoint.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final String? chatRoomId;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    this.chatRoomId,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: 'Flower',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        // タップされたアイコンに応じてページ遷移
         switch (index) {
    case 0:
      if (selectedIndex != 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomPage(chatRoomId: chatRoomId ?? '')));
      }
      break;
    case 1:
      if (selectedIndex != 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage()));
      }
      break;
    case 2:
      if (selectedIndex != 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FlowerPointPage()));
      }
      break;
  }
},
    );
  }
}
