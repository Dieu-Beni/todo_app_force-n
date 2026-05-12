import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/datasources/task_local_datasource.dart';
import '../../data/datasources/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';

final taskBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('Task box must be overridden in main');
});

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSourceImpl(ref.watch(taskBoxProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    remoteDataSource: ref.watch(taskRemoteDataSourceProvider),
    localDataSource: ref.watch(taskLocalDataSourceProvider),
  );
});

enum TaskStatus { initial, loading, loaded, error }

class TaskState {
  final TaskStatus status;
  final List<Task> tasks;
  final String? errorMessage;
  final TaskPriority? filterPriority;
  final TaskEtat? filterEtat;
  final String searchQuery;
  
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.errorMessage,
    this.filterPriority,
    this.filterEtat,
    this.searchQuery = '',
  });
  
  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    String? errorMessage,
    TaskPriority? filterPriority,
    TaskEtat? filterEtat,
    String? searchQuery,
    bool clearFilter = false,
    bool clearEtatFilter = false
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage,
      filterPriority: clearFilter ? null : (filterPriority ?? this.filterPriority),
      filterEtat: clearEtatFilter ? null : (filterEtat ?? this.filterEtat),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  
  List<Task> get filteredTasks {
    var filtered = tasks;
    
    if (filterPriority != null) {
      filtered = filtered.where((task) => task.priorite == filterPriority).toList();
    }

    if(filterEtat != null){
      filtered = filtered.where((task)=> task.etat == filterEtat).toList();
    }
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((task) =>
        task.titre.toLowerCase().contains(searchQuery.toLowerCase()) ||
        task.contenu.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _repository;
  
  TaskNotifier(this._repository) : super(const TaskState());
  
  Future<void> loadTasks() async {
    state = state.copyWith(status: TaskStatus.loading);
    try {
      final tasks = await _repository.getTasks();
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: tasks,
      );

    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
  
  Future<void> createTask(Task task) async {
    try {
      await _repository.createTask(task);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
  
  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> completeTask(String id) async {
    try {
      await _repository.completeTask(id);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
  
  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
  
  void setFilter(TaskPriority? priority) {
    if (priority == null) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterPriority: priority);
    }
  }

  void setEtat(TaskEtat? etat){
    if(etat == null){
      state = state.copyWith(clearEtatFilter: true);
    }else{
      state = state.copyWith(filterEtat: etat);
    }
  }
  
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
  
  void clearFilters() {
    state = state.copyWith(searchQuery: '', clearFilter: true, clearEtatFilter: true);
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref.watch(taskRepositoryProvider));
});
