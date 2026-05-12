import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;
  
  @override
  Future<User> login(String email, String password) async {
    final userModel = await _remoteDataSource.login(email, password);
    await _localDataSource.cacheUser(userModel);
    if (userModel.token != null) {
      await _localDataSource.saveToken(userModel.token!);
    }
    return userModel;
  }
  
  @override
  Future<User> register(
    String email,
    String password,
    String fullName,
    String? phone,
  ) async {
    final userModel = await _remoteDataSource.register(
      email,
      password,
      fullName,
      phone,
    );
    await _localDataSource.cacheUser(userModel);
    if (userModel.token != null) {
      await _localDataSource.saveToken(userModel.token!);
    }
    return userModel;
  }
  
  @override
  Future<User?> getCurrentUser() async {
    return await _localDataSource.getCachedUser();
  }
  
  @override
  Future<void> logout() async {
    await _localDataSource.clearCache();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.hasToken();
  }
}
