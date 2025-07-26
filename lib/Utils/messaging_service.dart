import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> init() async {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  await initLocalNotifications();

  NotificationSettings settings = await _fcm.requestPermission();

  String? token = await _fcm.getToken();
  print("✅ FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message received: ${message.notification?.title} - ${message.notification?.body}');
    showLocalNotification(message); 
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🚀 App opened from notification. Data: ${message.data}');
  });
}



Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

void showLocalNotification(RemoteMessage message) {

    final BigTextStyleInformation styleInformation = BigTextStyleInformation(
    message.data['body'] ?? message.notification?.body ?? '',
    contentTitle: message.data['title'] ?? message.notification?.title ?? 'Notification',
    htmlFormatContent: true,
    htmlFormatContentTitle: true,
  );

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'custom_channel_id',
    'Custom Channel',
    channelDescription: 'Used for custom notifications',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: styleInformation,
    largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  );

   NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    message.notification?.title ?? 'Notification',
    message.notification?.body ?? '',
    platformDetails,


  );
}


  
}
