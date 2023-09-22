import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_0818/parts/header.dart';
import 'package:flutter_application_0818/registar.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'top.dart';
import 'package:firebase_database/firebase_database.dart'; // 追加

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  // ユーザーのログイン状態を確認するメソッド
  bool userAlreadyLoggedIn() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Googleアカウントの表示名
  String _displayName = "";
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  Future<bool> userAlreadyLoggedIn() async {
    User? currentUser = await FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  Future<void> _login() async {
    // Google認証
    GoogleSignInAccount? signinAccount = await googleLogin.signIn();
    if (signinAccount == null) return;
    GoogleSignInAuthentication auth = await signinAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );

    // 認証情報をFirebaseに登録
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      setState(() {
        // 画面を更新
        _displayName = user.displayName!;
      });

      // Realtime Databaseからユーザー情報を取得
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users').child(user.uid);

    userRef.once().then((DatabaseEvent event) {
  DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          // ユーザー情報が存在する場合はTopPageへ遷移
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TopPage()),
          );
        } else {
          // ユーザー情報が存在しない場合はDataInputFormへ遷移
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DataInputForm()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("202へようこそ $_displayName", style: TextStyle(fontSize: 50)),
            TextButton(
              onPressed: _login, // _loginメソッドを呼ぶように修正
              child: const Text(
                'ログインする',
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // ユーザーのログイン状態を確認するメソッド
  bool userAlreadyLoggedIn() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Firebaseの初期化が完了したかどうかを確認
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return userAlreadyLoggedIn()
                ? Scaffold(
                    appBar: Header(),
                    body: TopPage(),
                  )
                : LoginPage();
          }
          // Firebaseの初期化がまだ完了していない場合はローディング画面などを表示
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
