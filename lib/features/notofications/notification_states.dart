import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<NotificationItem> notifications;

  const NotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationItem>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, notifications];
}

class NotificationItem extends Equatable {
  final String title;
  final String message;
  final NotificationType type;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [title, message, type];
}

enum NotificationType { reminder, upcoming, completed, due }
