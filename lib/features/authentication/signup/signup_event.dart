import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupNameChanged extends SignupEvent {
  final String name;
  SignupNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  SignupEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class SignupDobChanged extends SignupEvent {
  final DateTime dob;
  SignupDobChanged(this.dob);
  @override
  List<Object?> get props => [dob];
}

class SignupPhoneChanged extends SignupEvent {
  final String phone;
  SignupPhoneChanged(this.phone);
  @override
  List<Object?> get props => [phone];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  SignupPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class SignupPasswordVisibilityToggled extends SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final DateTime? dob;
  SignupSubmitted({required this.name, required this.email, required this.password, required this.phone, this.dob});
  @override
  List<Object?> get props => [name, email, password, phone, dob];
}
