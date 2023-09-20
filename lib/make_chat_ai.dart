import 'package:cloud_functions/cloud_functions.dart';

Future<String> makeChatGentler(String message) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('makeChatGentler');
  final response = await callable.call(<String, dynamic>{
    'text': message,
  });

  return response.data['message'];
}
