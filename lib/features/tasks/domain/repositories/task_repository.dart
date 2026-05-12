import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> getTask(String id);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task> completeTask(String id);
  Future<List<Task>> searchTasks(String query);
  Future<List<Task>> filterTasks(TaskPriority? priority);
}
