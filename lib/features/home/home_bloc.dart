import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<dynamic> _allTasks = [];
  HomeBloc() : super(HomeState(date: DateTime.now())) {
    on<HomeDateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<HomeSearchChanged>((event, emit) {
      final query = event.query.toLowerCase();
      final filtered = _allTasks.where((task) {
        final title = (task['title'] ?? '').toString().toLowerCase();
        return title.contains(query);
      }).toList();
      emit(state.copyWith(searchQuery: event.query, tasks: filtered));
    });
    on<HomeTabChanged>((event, emit) {
      emit(state.copyWith(selectedTab: event.tabIndex));
    });
    on<HomeFetchTasks>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('todos')
            .orderBy('date')
            .get();
        final tasks = snapshot.docs.map((doc) => doc.data()).toList();
        _allTasks = tasks;
        // Apply search filter if any
        final query = state.searchQuery.toLowerCase();
        final filtered = query.isEmpty
            ? tasks
            : tasks.where((task) {
                final title = (task['title'] ?? '').toString().toLowerCase();
                return title.contains(query);
              }).toList();
        emit(state.copyWith(isLoading: false, tasks: filtered));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
    on<HomeAddTask>((event, emit) async {
      try {
        print('firebase data----'
            'id: ${event.id}, '
            'title: ${event.title}, '
            'description: ${event.description}, '
            'priority: ${event.priority}, '
            'date: ${event.date.toIso8601String()}, '
            'time: ${event.time}');
        await FirebaseFirestore.instance.collection('todos').doc(event.id).set({
          'id': event.id,
          'title': event.title,
          'description': event.description,
          'priority': event.priority,
          'date': event.date.toIso8601String(),
          'time': event.time,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Optionally, update the state or fetch tasks again
        // emit(state.copyWith(...));
      } catch (e) {
        // Optionally, emit an error state
        emit(state.copyWith(error: e.toString()));
      }
    });
    on<HomeDeleteTask>((event, emit) async {
      try {
        await FirebaseFirestore.instance.collection('todos').doc(event.id).delete();
        add(HomeFetchTasks()); // Refresh the list after deletion
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}
