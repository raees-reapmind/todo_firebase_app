import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_page.dart';
import 'package:management_and_scheduling_app/features/splash_screen/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management_and_scheduling_app/features/home/home_page.dart'; 
import 'package:management_and_scheduling_app/features/onboarding/boost_productivity_screen.dart';

import '../features/onboarding/stay_organised_screen.dart';
import '../features/splash_screen/splash_bloc.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? onboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onboardingComplete == null) { 
        return const StayOrganisedScreen();
    }
    if (!onboardingComplete!) {
      // Show onboarding
      return const BoostProductivityScreen();
    }
    // After onboarding, show auth logic
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BlocProvider(
            create: (_) => SplashBloc()..add(SplashEvent()),
            child: const SplashPage(),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
