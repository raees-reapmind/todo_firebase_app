import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_event.dart';
import 'calendar_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  List<dynamic> _allTasks = [];
  CalendarBloc()
      : super(CalendarState(selectedDate: DateTime.now())) {
    on<CalendarFetchTasks>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('todos')
            .orderBy('date')
            .get();
        final tasks = snapshot.docs.map((doc) => doc.data()).toList();
        _allTasks = tasks;
        final filtered = _filterTasksByDate(_allTasks, state.selectedDate);
        emit(state.copyWith(isLoading: false, tasks: filtered));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
    on<CalendarDateChanged>((event, emit) {
      final filtered = _filterTasksByDate(_allTasks, event.selectedDate);
      emit(state.copyWith(selectedDate: event.selectedDate, tasks: filtered));
    });
  }

  List<dynamic> _filterTasksByDate(List<dynamic> tasks, DateTime date) {
    return tasks.where((task) {
      if (task['date'] == null) return false;
      final taskDate = DateTime.tryParse(task['date']);
      return taskDate != null &&
          taskDate.year == date.year &&
          taskDate.month == date.month &&
          taskDate.day == date.day;
    }).toList();
  }
}
