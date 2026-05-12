import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  
  TaskRepositoryImpl({
    required TaskRemoteDataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;
  
  @override
  Future<List<Task>> getTasks() async {
    try {
      final remoteTasks = await _remoteDataSource.getTasks();
      await _localDataSource.cacheTasks(remoteTasks);
      return remoteTasks;
    } catch (e) {
      return await _localDataSource.getTasks();
    }
  }
  
  @override
  Future<Task> getTask(String id) async {
    try {
      final remoteTask = await _remoteDataSource.getTask(id);
      await _localDataSource.cacheTask(remoteTask);
      return remoteTask;
    } catch (e) {
      final localTask = await _localDataSource.getTask(id);
      if (localTask != null) {
        return localTask;
      }
      rethrow;
    }
  }
  
  @override
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    try {
      final remoteTask = await _remoteDataSource.createTask(taskModel);
      await _localDataSource.cacheTask(remoteTask);
      return remoteTask;
    } catch (e) {
      await _localDataSource.cacheTask(taskModel);
      return taskModel;
    }
  }
  
  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    try {
      final remoteTask = await _remoteDataSource.updateTask(taskModel);
      await _localDataSource.cacheTask(remoteTask);
      return remoteTask;
    } catch (e) {
      await _localDataSource.cacheTask(taskModel);
      return taskModel;
    }
  }
  
  @override
  Future<void> deleteTask(String id) async {
    try {
      await _remoteDataSource.deleteTask(id);
    } catch (_) {
    } finally {
      await _localDataSource.deleteTask(id);
    }
  }
  
  @override
  Future<List<Task>> searchTasks(String query) async {
    final tasks = await getTasks();
    return tasks.where((task) => 
      task.titre.toLowerCase().contains(query.toLowerCase()) ||
      task.contenu.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  @override
  Future<List<Task>> filterTasks(TaskPriority? priority) async {
    final tasks = await getTasks();
    if (priority == null) {
      return tasks;
    }
    return tasks.where((task) => task.priorite == priority).toList();
  }

  @override
  Future<Task> completeTask(String id) async {
    try {
      final remoteTask = await _remoteDataSource.completeTask(id);
      await _localDataSource.cacheTask(remoteTask);
      return remoteTask;
    } catch (e) {
      final localTask = await _localDataSource.getTask(id);
      if (localTask != null) {
        return localTask;
      }
      rethrow;
    }
  }
}
