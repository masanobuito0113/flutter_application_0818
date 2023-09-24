import 'package:flutter/material.dart';
import 'package:flutter_application_0818/chat_room.dart';
import 'package:flutter_application_0818/schedule.dart';
import 'package:flutter_application_0818/flowerPoint.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemSelected,
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
      onTap: onItemSelected,
    );
  }
}
 