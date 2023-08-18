import 'package:flutter/material.dart';
 
class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
 
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
            title: Image.asset('images/202logo.png',
            height: 100,
            width: 100,
          ),
            // leading: Padding(
            //   padding: const EdgeInsets.fromLTRB(0,0,0,0),
            //   child: Image.asset('images/202logo.png'
            //   , width: 80, // 画像の幅を調整
            //    ),
            // ),
          actions: <Widget>[ // actionsを追加
      Padding( // Paddingを追加
        padding: const EdgeInsets.all(8.0),
        child: IconButton( // IconButtonを追加
        icon: Icon(Icons.settings), 
           color: Colors.black, // アイコンの色を変更//Iconsの設定アイコンを指定
          onPressed: () {}, // 動作は空
        ),
      ),
    ],   
    );
  }
}