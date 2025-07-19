import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/features/authentication/signup/signup_bloc.dart';
import 'package:management_and_scheduling_app/features/authentication/signup/signup_screen.dart';
import 'package:management_and_scheduling_app/features/authentication/signup/signup_states.dart'; 

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          // Handle login success, errors, etc. here if needed
        },
        child: const SignupScreen(),
      ),
    );
  }
} 


