import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalendarFetchTasks extends CalendarEvent {}

class CalendarDateChanged extends CalendarEvent {
  final DateTime selectedDate;
  CalendarDateChanged(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}
