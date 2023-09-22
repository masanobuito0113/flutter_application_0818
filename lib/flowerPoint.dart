import 'package:flutter/material.dart';
import 'package:flutter_application_0818/top.dart';

class FlowerPointPage extends StatelessWidget {
  final String? chatRoomId;

  FlowerPointPage({this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  } else {
    Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => TopPage()),
   );
  }
},
    ),
        title: Text('Flower Point Page'),
      ),
      body: Center(
        child: Text('This is an empty page'),
      ),
    );
  }
}
