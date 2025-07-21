import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? name;
  final String? role;
  final String? imageUrl;

  const ProfileState({
    this.isLoading = false,
    this.error,
    this.name,
    this.role,
    this.imageUrl,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? name,
    String? role,
    String? imageUrl,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      name: name ?? this.name,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, name, role, imageUrl];
}
