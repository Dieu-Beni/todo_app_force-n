import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    String? nom,
    String? phone,
    String? email,
    String? profileImage,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> updateProfile({
    String? nom,
    String? phone,
    String? email,
    String? profileImage,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nom != null) data['nom'] = nom;
      if (phone != null) data['phone'] = phone;
      if (email != null) data['email'] = email;
      if (profileImage != null) data['profileImage'] = profileImage;

      final response = await _dioClient.put(
        ApiConstants.profile,
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
