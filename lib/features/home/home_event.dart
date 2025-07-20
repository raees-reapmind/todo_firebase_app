import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeDateChanged extends HomeEvent {
  final DateTime date;
  HomeDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class HomeSearchChanged extends HomeEvent {
  final String query;
  HomeSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class HomeTabChanged extends HomeEvent {
  final int tabIndex;
  HomeTabChanged(this.tabIndex);
  @override
  List<Object?> get props => [tabIndex];
}

class HomeFetchTasks extends HomeEvent {}

class HomeAddTask extends HomeEvent {
  final String id;
  final String title;
  final String? description;
  final String priority;
  final DateTime date;
  final String time;

  HomeAddTask({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [id, title, description, priority, date, time];
}

class HomeDeleteTask extends HomeEvent {
  final String id;
  HomeDeleteTask(this.id);
  @override
  List<Object?> get props => [id];
}
