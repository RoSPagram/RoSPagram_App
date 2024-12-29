import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'shared_prefs.dart';
import 'google_auth.dart';

final firebaseMessaging = FirebaseMessaging.instance;

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // print('==========FCM_BACKGROUND_MSG==========');
  // print('MESSAGE_ID: ${message.messageId}');
  // print('MESSAGE_DATA: ${message.data}');
  // print('======================================');
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

// Future<void> setupInteractedMessage() async {
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) _handleMessage(initialMessage);
//   FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
//   FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
// }

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initFirebase() async {
  await Firebase.initializeApp();
  final notificationSettings = await firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  await setupFlutterNotifications();
  // setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  final apnsToken = await firebaseMessaging.getAPNSToken();
  firebaseMessaging.getToken().then((fcmToken) {
    print('==========GET_TOKEN: $fcmToken');
    SharedPrefs.instance.setString('fcm_token', fcmToken as String);
  });
  firebaseMessaging.onTokenRefresh.listen((fcmToken) {
    print('==========REFRESH_TOKEN: $fcmToken');
    SharedPrefs.instance.setString('fcm_token', fcmToken);
  });
}

Future<void> sendPushMessage(String token, String title, String body, [Object? data]) async {
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
      "android": {
        "priority": "HIGH",
        "notification": {
          "channel_id": "high_importance_channel",
          "notification_priority": "PRIORITY_MAX",
        }
      },
      "notification": {
        "body": body,
        "title": title,
      },
      "data": data,
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
