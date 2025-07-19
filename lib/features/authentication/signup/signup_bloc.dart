import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_states.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name, error: null));
    });
    on<SignupEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, error: null));
    });
    on<SignupDobChanged>((event, emit) {
      emit(state.copyWith(dob: event.dob, error: null));
    });
    on<SignupPhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone, error: null));
    });
    on<SignupPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
    on<SignupPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
    on<SignupSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
      // Validation
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(state.copyWith(isLoading: false, error: "Email and password cannot be empty.", isSuccess: false));
        return;
      }
      if (event.password.length < 6) {
        emit(state.copyWith(isLoading: false, error: "Password must be at least 6 characters.", isSuccess: false));
        return;
      }
      try {
        // Firebase signup
      print('SignupSubmitted: email = \'${event.email}\', password = \'${event.password}\', name = \'${event.name}\', phone = \'${event.phone}\', dob = \'${event.dob}\'');

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true, error: null));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, error: e.message ?? "Signup failed.", isSuccess: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: "Signup failed.", isSuccess: false));
      }
    });
  }
}
