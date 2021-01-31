import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationManager{
final String serverToken = 'AAAA3nqIZsw:APA91bE8u-JCjKTOs67SGG9U528YMcQ2zjZuXt1tmFvVFYgW9e-0twsShQXmmrYn2FkorW9bsVpKTppVCmVGx1sEwV6tkQRQd_cNSYTPZ5FXskA4ZqVrOyfxgXDpAB27Fg_7ocqO098b';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage(String fcmTok, String title, String body) async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': '$body',
         'title': '$title'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'title' : '$title',
         'body' : '$body',
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': '/topics/TopicToListen',
     },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
     Completer<Map<String, dynamic>>();

  // firebaseMessaging.configure(
  //   onMessage: (Map<String, dynamic> message) async {
  //     completer.complete(message);
  //   },
  // );

  return completer.future;
  }
}


