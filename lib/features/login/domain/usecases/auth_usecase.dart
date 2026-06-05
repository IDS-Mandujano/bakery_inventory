import '../entities/User.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<User> executeLogin(String email, String password) async {
    return await repository.onLogin(email, password);
  }
}