import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearCache();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  
  AuthLocalDataSourceImpl(this._secureStorage);
  
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = await _secureStorage.read(key: StorageKeys.user);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return UserModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await _secureStorage.write(key: StorageKeys.user, value: jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: StorageKeys.accessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to get token: $e');
    }
  }
  
  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: StorageKeys.accessToken, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save token: $e');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await _secureStorage.delete(key: StorageKeys.user);
      await _secureStorage.delete(key: StorageKeys.accessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
  
  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
