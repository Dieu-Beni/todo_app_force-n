import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _repository;
  
  GetTasksUseCase(this._repository);
  
  Future<List<Task>> call() {
    return _repository.getTasks();
  }
}

class GetTaskUseCase {
  final TaskRepository _repository;
  
  GetTaskUseCase(this._repository);
  
  Future<Task> call(String id) {
    return _repository.getTask(id);
  }
}

class CreateTaskUseCase {
  final TaskRepository _repository;
  
  CreateTaskUseCase(this._repository);
  
  Future<Task> call(Task task) {
    return _repository.createTask(task);
  }
}

class UpdateTaskUseCase {
  final TaskRepository _repository;
  
  UpdateTaskUseCase(this._repository);
  
  Future<Task> call(Task task) {
    return _repository.updateTask(task);
  }
}

class CompleteTaskUseCase {
  final TaskRepository _repository;

  CompleteTaskUseCase(this._repository);

  Future<Task> call(String id) {
    return _repository.completeTask(id);
  }
}

class DeleteTaskUseCase {
  final TaskRepository _repository;
  
  DeleteTaskUseCase(this._repository);
  
  Future<void> call(String id) {
    return _repository.deleteTask(id);
  }
}

class SearchTasksUseCase {
  final TaskRepository _repository;
  
  SearchTasksUseCase(this._repository);
  
  Future<List<Task>> call(String query) {
    return _repository.searchTasks(query);
  }
}

class FilterTasksUseCase {
  final TaskRepository _repository;
  
  FilterTasksUseCase(this._repository);
  
  Future<List<Task>> call(TaskPriority? priority) {
    return _repository.filterTasks(priority);
  }
}
