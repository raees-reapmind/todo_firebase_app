import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_states.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(
        isLoading: false,
        notifications: [
          NotificationItem(
            title: '⚠️ Reminder',
            message: 'Your interview with Sarah starts in 30 minutes. Get ready!',
            type: NotificationType.reminder,
          ),
          NotificationItem(
            title: '⏳ Upcoming Task',
            message: 'Don\'t forget to complete Alex Interview before the deadline.',
            type: NotificationType.upcoming,
          ),
          NotificationItem(
            title: '✅ Task Completed',
            message: 'Great job! You\'ve checked off a task. Keep going!',
            type: NotificationType.completed,
          ),
          NotificationItem(
            title: '⏳ Task Due',
            message: 'Your task "Submit Report" is due in 1 hour. Stay on track!',
            type: NotificationType.due,
          ),
        ],
      ));
    });
  }
}
