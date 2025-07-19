import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../onboarding/stay_organised_Screen.dart';
import 'splash_bloc.dart';
import 'splash_screen.dart'; 

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashFinished) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const StayOrganisedScreen(),
            ),
          );
        }
      },
      child: const SplashScreen(),
    );
  }
} 