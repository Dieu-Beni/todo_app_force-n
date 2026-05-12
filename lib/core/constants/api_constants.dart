class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String tasks = '/tasks';
  static const String profile = '/profile';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}

class StorageKeys {
  static const String accessToken = 'token';
  static const String user = 'user';
  static const String tasks = 'tasks';
}

class AppConstants {
  static const String appName = 'Task Manager';
  static const int maxRetryAttempts = 3;
}
