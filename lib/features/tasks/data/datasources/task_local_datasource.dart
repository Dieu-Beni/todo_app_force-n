import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel?> getTask(String id);
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<void> cacheTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> clearTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box _taskBox;
  
  TaskLocalDataSourceImpl(this._taskBox);
  
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final tasks = _taskBox.get(StorageKeys.tasks);
      if (tasks != null) {
        final List<dynamic> data = jsonDecode(tasks);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to get cached tasks: $e');
    }
  }
  
  @override
  Future<TaskModel?> getTask(String id) async {
    try {
      final tasks = await getTasks();
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    try {
      final data = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await _taskBox.put(StorageKeys.tasks, data);
    } catch (e) {
      throw CacheException(message: 'Failed to cache tasks: $e');
    }
  }
  
  @override
  Future<void> cacheTask(TaskModel task) async {
    try {
      final tasks = await getTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index >= 0) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }
      await cacheTasks(tasks);
    } catch (e) {
      throw CacheException(message: 'Failed to cache task: $e');
    }
  }
  
  @override
  Future<void> deleteTask(String id) async {
    try {
      final tasks = await getTasks();
      tasks.removeWhere((task) => task.id == id);
      await cacheTasks(tasks);
    } catch (e) {
      throw CacheException(message: 'Failed to delete task: $e');
    }
  }
  
  @override
  Future<void> clearTasks() async {
    try {
      await _taskBox.delete(StorageKeys.tasks);
    } catch (e) {
      throw CacheException(message: 'Failed to clear tasks: $e');
    }
  }
}
