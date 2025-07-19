import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(date: DateTime.now())) {
    on<HomeDateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<HomeSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });
    on<HomeTabChanged>((event, emit) {
      emit(state.copyWith(selectedTab: event.tabIndex));
    });
    on<HomeFetchTasks>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1));
      // Simulate empty tasks for now
      emit(state.copyWith(isLoading: false, tasks: []));
    });
  }
}
