import '../entities/User.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<User> executeLogin(String email, String password) async {
    return await repository.onLogin(email, password);
  }

  Future<User> executeRegister(String email, String user, String password) async {
    return await repository.onRegister(email, user, password);
  }

  Future<User> executeLogout(String id) async {
    return await repository.onLogout(id);
  }
}