import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'shared_prefs.dart';
import 'google_auth.dart';

final firebaseMessaging = FirebaseMessaging.instance;

Future<void> _handleMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('==========FCM_BACKGROUND_MSG==========');
  print('MESSAGE_ID: ${message.messageId}');
  print('MESSAGE_DATA: ${message.data}');
  print('======================================');
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) _handleMessage(initialMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleMessage);
  FirebaseMessaging.onMessage.listen(_handleMessage);
}

void initFirebase() async {
  await Firebase.initializeApp();
  setupInteractedMessage();
  final notificationSettings = await firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  firebaseMessaging.getToken().then((fcmToken) {
    SharedPrefs.instance.setString('fcm_token', fcmToken as String);
  });
  firebaseMessaging.onTokenRefresh.listen((fcmToken) {
    SharedPrefs.instance.setString('fcm_token', fcmToken as String);
  });
}

Future<void> sendPushMessage(String token, String title, String body) async {
  // final String serverKey = 'YOUR_SERVER_KEY';
  final String fcmUrl = dotenv.env['FCM_URL'] as String;
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + accessToken,
  };

  final payload = {
    "message": {
      "token": token,
      "notification": {
        "body": body,
        "title": title
      },
    }
  };

  final response = await http.post(
    Uri.parse(fcmUrl),
    headers: headers,
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('푸시 메시지가 성공적으로 전송되었습니다.');
  } else {
    print('푸시 메시지 전송에 실패했습니다. 상태 코드: ${response.statusCode}');
    print(response.body);
  }
}
