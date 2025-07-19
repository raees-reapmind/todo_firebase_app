import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, error: null));
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
      print('SignupSubmitted: email = \'${state.email}\', password = \'${state.password}\'');
        
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, error: e.message ?? "Login failed"));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Login failed"));
      }
    });
    on<LoginPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
  }
}
