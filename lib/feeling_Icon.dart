import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeelingIcon extends StatefulWidget {
  final String ownerUid;
  final String partnerUid;

  const FeelingIcon({
    Key? key,
    required this.ownerUid,
    required this.partnerUid,
  }) : super(key: key);

  @override
  _FeelingIconState createState() => _FeelingIconState();
}

class _FeelingIconState extends State<FeelingIcon> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  void _sendFeelingIcon() {
    // アイコンがタップされたときにFirebaseにデータを送信する処理をここに記述します。
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sentiment_very_satisfied), // 送信する感情アイコンを選択してください。
      onPressed: _sendFeelingIcon,
    );
  }
}
