import 'package:flutter_bloc/flutter_bloc.dart';

class SplashEvent {}

class SplashState {}

class SplashInitial extends SplashState {}

class SplashFinished extends SplashState {}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashFinished());
    });
  }
}