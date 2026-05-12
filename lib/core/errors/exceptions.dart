class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException({this.message = 'Server error', this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException({this.message = 'No internet connection'});
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  
  CacheException({this.message = 'Cache error'});
  
  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  
  AuthException({this.message = 'Authentication failed'});
  
  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  
  ValidationException({this.message = 'Validation error'});
  
  @override
  String toString() => 'ValidationException: $message';
}
