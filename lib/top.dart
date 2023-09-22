import 'package:flutter/material.dart';
import 'package:flutter_application_0818/flowerPoint.dart';
import 'package:flutter_application_0818/schedule.dart';
import 'chat_room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_0818/parts/custom_bottom_navigation_bar.dart'; 


class TopPage extends StatelessWidget {
  final String? chatRoomId;

  TopPage({this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      // home: ChatRoomButton(chatRoomId: chatRoomId),
       home: Scaffold(
        // CustomBottomNavigationBarをScaffoldのbottomNavigationBarに配置
        bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
        body: ChatRoomButton(chatRoomId: chatRoomId),
      ),
    );
  }
}

class ChatRoomButton extends StatelessWidget {
  final String? chatRoomId;

  const ChatRoomButton({Key? key, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(chatRoomId: chatRoomId ?? ''), // ここでchatRoomIdを渡します
                  ),
                );
              },
              child: Text(
                'Chat',
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              },
              child: Text(
                'Schedule', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlowerPointPage()),
                 );
              },
              child: Text(
                'FlowerPoint', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // 背景色
                          borderRadius: BorderRadius.circular(10.0), // 角を丸くする
                          border: Border.all(
                            color: Colors.black, // フチの色
                            width: 4.0, // フチの太さ
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Send your feelings!!', 
                              style: GoogleFonts.archivoBlack(
                                textStyle: Theme.of(context).textTheme.headline4,
                                color: Color(0xFF000000),
                                fontSize: 30.0,
                            )),
                                SizedBox(height: 10.0), // スペースを追加
                                Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent), // 背景色を透明に
                                  elevation: MaterialStateProperty.all(0), // 影を削除
                                  padding: MaterialStateProperty.all(EdgeInsets.zero), // パディングを削除
                                  shape: MaterialStateProperty.all(
                                    CircleBorder(), // クリックエリアを円形に（オプショナル）
                                  ),
                                ),
                                child: const Icon(
                                  Icons.sentiment_very_satisfied, 
                                  color: Color(0xFF000000),
                                  size: 48.0,
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent), // 背景色を透明に
                                  elevation: MaterialStateProperty.all(0), // 影を削除
                                  padding: MaterialStateProperty.all(EdgeInsets.zero), // パディングを削除
                                  shape: MaterialStateProperty.all(
                                    CircleBorder(), // クリックエリアを円形に（オプショナル）
                                  ),
                                ),
                                child: const Icon(
                                  Icons.sentiment_very_satisfied, 
                                  color: Color(0xFF000000),
                                  size: 48.0,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent), // 背景色を透明に
                                  elevation: MaterialStateProperty.all(0), // 影を削除
                                  padding: MaterialStateProperty.all(EdgeInsets.zero), // パディングを削除
                                  shape: MaterialStateProperty.all(
                                    CircleBorder(), // クリックエリアを円形に（オプショナル）
                                  ),
                                ),
                                child: Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Color(0xFF000000),
                                  size: 48.0,
                                ),
                              ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent), // 背景色を透明に
                                      elevation: MaterialStateProperty.all(0), // 影を削除
                                      padding: MaterialStateProperty.all(EdgeInsets.zero), // パディングを削除
                                      shape: MaterialStateProperty.all(
                                        CircleBorder(), // クリックエリアを円形に（オプショナル）
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 48.0,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

            TextButton(
              onPressed: () {
                // 他のボタンの処理
              },
              child: Text(
                'Setting', // ボタンのテキスト
                style: GoogleFonts.archivoBlack(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Color(0xFF000000),
                  fontSize: 48.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


