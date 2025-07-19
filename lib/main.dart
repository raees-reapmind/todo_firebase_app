import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/features/splash_screen/splash_bloc.dart';
import 'package:management_and_scheduling_app/features/splash_screen/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:management_and_scheduling_app/features/home/home_page.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_screen.dart';

import 'Utils/auth_check.dart';
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
 
