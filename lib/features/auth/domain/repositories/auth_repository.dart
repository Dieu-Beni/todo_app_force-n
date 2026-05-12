import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName, String? phone);
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
