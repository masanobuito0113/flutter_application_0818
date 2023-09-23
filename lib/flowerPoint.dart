import 'package:flutter/material.dart';
import 'package:flutter_application_0818/top.dart';

class FlowerPointPage extends StatelessWidget {
  final String? chatRoomId;

  FlowerPointPage({this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TopPage()),
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TopPage()),
                );
              }
            },
          ),
          title: const Text('Flower Point Page'),
        ),
        body: Center(
          child: const Text('This is an empty page'),
        ),
      ),
    );
  }
}
