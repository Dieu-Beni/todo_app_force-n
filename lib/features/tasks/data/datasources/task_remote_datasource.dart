import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<TaskModel> completeTask(String id);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final DioClient _dioClient;
  
  TaskRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dioClient.get(ApiConstants.tasks);
      
      if (response.statusCode == 200) {

        print(response.data);
        final List<dynamic> data = response.data;
        print(data);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get tasks',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<TaskModel> getTask(String id) async {
    try {
      final response = await _dioClient.get('${ApiConstants.tasks}/$id');
      
      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.tasks,
        data: task.toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to create task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dioClient.put(
        '${ApiConstants.tasks}/${task.id}',
        data: task.toJson(),
      );
      
      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to update task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dioClient.delete('${ApiConstants.tasks}/$id');
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TaskModel> completeTask(String id) async {
    try {
      final response = await _dioClient.put(
        '${ApiConstants.tasks}/complete/${id}'
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to update task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
