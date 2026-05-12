import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String fullName, String? phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  
  AuthRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<UserModel> register(
    String email,
    String password,
    String fullName,
    String? phone,
  ) async {
    try {
      // print("Phone ${phone!}");
      final response = await _dioClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'nom': fullName,
          'phone': phone,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
          // print(response.data);
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erreur de d\'enregistrement',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
