import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_bloc.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_screen.dart';
import 'package:management_and_scheduling_app/features/authentication/login/login_states.dart'; 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          // Handle login success, errors, etc. here if needed
        },
        child: const LoginScreen(),
      ),
    );
  }
} 


