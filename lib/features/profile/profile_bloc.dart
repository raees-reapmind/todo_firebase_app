import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_states.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>((event, emit) async {
      emit(state.copyWith(isLoading: true)); 
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(
        isLoading: false,
        name: 'John Doe',
        role: 'Marketing Manager',
        imageUrl: null, 
      ));
    });
    on<EditProfile>((event, emit) { 
    });
    on<ChangePassword>((event, emit) { 
    });
    on<Logout>((event, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(state.copyWith(error: 'logout'));
    });
  }
}
