import 'package:flutter/material.dart';
import 'package:flutter_application_0818/flowerPoint.dart';
import 'package:flutter_application_0818/schedule.dart';
import 'chat_room.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_application_0818/parts/custom_bottom_navigation_bar.dart';

class TopPage extends StatefulWidget {
  final String? chatRoomId;

  TopPage({this.chatRoomId});

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   selectedIndex: _selectedIndex,
        //   onItemSelected: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //     _pageController.animateToPage(index,
        //         duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        //   },
        // ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            ChatRoom(chatRoomId: widget.chatRoomId),
            SchedulePage(),
            FlowerPointPage(),
          ],
        ),
      ),
    );
  }
}

class ChatRoom extends StatelessWidget {
  final String? chatRoomId;

  const ChatRoom({Key? key, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
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
                              'Send your feelings!!!!', 
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
                                  Icons.sentiment_neutral, 
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: PartnersFeeling(),
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
        ],
      ),
    );
  }
}

class PartnersFeeling extends StatefulWidget {
  @override
  _PartnersFeelingState createState() => _PartnersFeelingState();
}

class _PartnersFeelingState extends State<PartnersFeeling> {
  IconData partnersFeelingIcon = Icons.sentiment_very_satisfied;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Partner's Feeling → ",
          style: GoogleFonts.archivoBlack(
            textStyle: Theme.of(context).textTheme.headline4,
            color: Color(0xFF000000),
            fontSize: 24.0,
          ),
        ),
        Icon(
          partnersFeelingIcon,
          size: 48.0,
          color: Color(0xFF000000),
        ),
      ],
    );
  }
}



// class CustomBottomNavigationBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;

//   CustomBottomNavigationBar({
//     required this.selectedIndex,
//     required this.onItemSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.schedule),
//           label: 'Schedule',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.local_florist),
//           label: 'Flower',
//         ),
//       ],
//       currentIndex: selectedIndex,
//       onTap: onItemSelected,
//     );
//   }
// }