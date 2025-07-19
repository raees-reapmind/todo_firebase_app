import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final DateTime date;
  final String searchQuery;
  final int selectedTab;
  final List<dynamic> tasks; // Replace dynamic with your Task model
  final bool isLoading;
  final String? error;

  const HomeState({
    required this.date,
    this.searchQuery = '',
    this.selectedTab = 0,
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    DateTime? date,
    String? searchQuery,
    int? selectedTab,
    List<dynamic>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      date: date ?? this.date,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [date, searchQuery, selectedTab, tasks, isLoading, error];
}
