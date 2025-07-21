import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:management_and_scheduling_app/features/home/home_bloc.dart';
import 'package:management_and_scheduling_app/features/home/home_screen.dart';
import 'package:management_and_scheduling_app/features/home/home_states.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) { 
        },
        child: const HomeScreen(),
      ),
    );
  }
} 


