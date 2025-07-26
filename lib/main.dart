import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart'; 

import 'Utils/auth_check.dart';
import 'Utils/messaging_service.dart';
// import your firebase_options.dart if using FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: 'AIzaSyBlu8uJnnOnodOLALySJ2I9nJGptvIyVJk',
    appId: '1:527581792984:android:b0016d49fb6b3a23df25ad',
    messagingSenderId: '527581792984',
    projectId: 'managementapp-5ef6c',
    storageBucket: 'managementapp-5ef6c.firebasestorage.app',
  ) 
  );
    await NotificationService().init();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
 
