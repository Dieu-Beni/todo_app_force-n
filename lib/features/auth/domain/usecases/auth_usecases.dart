import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<User> call(String email, String password) {
    return _repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  
  RegisterUseCase(this._repository);
  
  Future<User> call(String email, String password, String fullName, String? phone) {
    return _repository.register(email, password, fullName, phone);
  }
}

class LogoutUseCase {
  final AuthRepository _repository;
  
  LogoutUseCase(this._repository);
  
  Future<void> call() {
    return _repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  
  GetCurrentUserUseCase(this._repository);
  
  Future<User?> call() {
    return _repository.getCurrentUser();
  }
}

class IsLoggedInUseCase {
  final AuthRepository _repository;
  
  IsLoggedInUseCase(this._repository);
  
  Future<bool> call() {
    return _repository.isLoggedIn();
  }
}
