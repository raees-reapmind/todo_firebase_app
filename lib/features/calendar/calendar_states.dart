import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final List<dynamic> tasks; // Replace dynamic with your Task model if available
  final bool isLoading;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    List<dynamic>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedDate, tasks, isLoading, error];
}
