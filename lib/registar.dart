import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0818/Iinvitation.dart';
import 'package:flutter_application_0818/firebase_options.dart';
import 'package:flutter_application_0818/InviteCode.dart';
import 'package:flutter_application_0818/login.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DataInputForm());
}

FirebaseDatabase database = FirebaseDatabase.instance;

class DataInputForm extends StatefulWidget {
  @override
  _DataInputFormState createState() => _DataInputFormState();
}

class _DataInputFormState extends State<DataInputForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> anniversaries = [];
  List<Widget> anniversaryFields = [];
  Image? _img;
  Text? _text;

  // アップロード処理
  void _upload() async {
    final pickerFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }
    File file = File(pickerFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref("UL/upload-pic.png").putFile(file);
      setState(() {
        _img = null;
        _text = const Text("UploadDone");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('あなたの登録データをいれてください'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _fbKey,
            child: Column(
              children: [
                         Text('データ入力フォーム'),
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(labelText: '名前'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'nickname',
                  decoration: InputDecoration(labelText: 'ニックネーム'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                FormBuilderDateTimePicker(
                  name: 'birthdate',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(labelText: 'あなたの誕生日'),
                ),
                FormBuilderDateTimePicker(
                  name: 'wedding_anniversary',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(labelText: '結婚記念日'),
                ),

Column(
  children: [
    Text('ほかの記念日を追加する'),
    ...anniversaryFields,

    ElevatedButton(
      onPressed: () {
        setState(() {
          final int fieldIndex = anniversaryFields.length;
          anniversaryFields.add(
            Column(
              children: [
                FormBuilderTextField(
                  name: 'anniversary_description_$fieldIndex',
                  decoration: InputDecoration(labelText: '記念日の説明'),
                ),
                FormBuilderDateTimePicker(
                  name: 'anniversary_date_$fieldIndex',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: InputDecoration(labelText: '記念日の日付'),
                ),
              ],
            ),
          );
        });
      },
      child: Text('記念日を追加'),
    ),
    SizedBox(height: 20),

    // 画像アップロードボタンを配置
    Row(
      mainAxisAlignment: MainAxisAlignment.center, // ボタンを中央に配置
      children: [
FloatingActionButton(
  onPressed: _upload,
  child: const Row(
    children: [
      Icon(Icons.upload_outlined), // アップロードアイコン
      SizedBox(width: 8), // アイコンとテキストの間隔を設定
      Expanded(
        child: Text(
          'アイコン用の写真をUPする',
          overflow: TextOverflow.ellipsis, // 文字がはみ出した場合に省略記号で表示
          style: TextStyle(
            fontSize: 16, // フォントサイズを調整
            color: Colors.black, // テキストの色を設定
          ),
        ),
      ),
    ],
  ),
),
],
 ),

    // 画像またはテキストを表示
    if (_img != null) _img!,
    if (_text != null) _text!,

Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ボタンを水平方向に均等に配置
  children: [
    ElevatedButton(
      onPressed: () {
        _fbKey.currentState!.reset();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Text('Cancel'),
    ),

ElevatedButton(
  onPressed: () async {
    if (_fbKey.currentState!.saveAndValidate()) {
      final formData = _fbKey.currentState!.value;
      final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

      final Map<String, dynamic> userData = {
        'name': formData['name'],
        'nickname': formData['nickname'],
        'email': formData['email'],
        'birthdate': formData['birthdate'].toString(),
        'wedding_anniversary': formData['wedding_anniversary'].toString(),
        // ...
      };

      for (int i = 0; i < anniversaryFields.length; i++) {
        final anniversaryDescriptionKey = 'anniversary_description_$i';
        final anniversaryDateKey = 'anniversary_date_$i';
        userData[anniversaryDescriptionKey] = formData[anniversaryDescriptionKey];
        userData[anniversaryDateKey] = formData[anniversaryDateKey].toString();
      }

      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId != null) {
        await databaseReference.child('users').child(userId).set(userData);

        // この部分を削除し、直接InviteCodePageに移動する
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InviteCodePage(),
          ),
        );
      }
    }
  },
  child: Text('Submit'),
),

  ],
),

              ],
            ),
              ],
  
        ),
    ),
        ),
      ),
    );
  }
}