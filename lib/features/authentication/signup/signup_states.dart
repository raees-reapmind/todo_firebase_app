import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String name;
  final String email;
  final DateTime? dob;
  final String phone;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const SignupState({
    this.name = '',
    this.email = '',
    this.dob,
    this.phone = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  SignupState copyWith({
    String? name,
    String? email,
    DateTime? dob,
    String? phone,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [name, email, dob, phone, password, isPasswordVisible, isLoading, isSuccess, error];
}
