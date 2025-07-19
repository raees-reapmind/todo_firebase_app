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
