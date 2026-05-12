import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/domain/entities/user.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl {
  final ProfileRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  Future<User> updateProfile({
    String? nom,
    String? phone,
    String? email,
    String? profileImage,
  }) async {
    final user = await _remoteDataSource.updateProfile(
      nom: nom,
      phone: phone,
      email: email,
      profileImage: profileImage,
    );
    await _localDataSource.cacheUser(user);
    return user;
  }
}
