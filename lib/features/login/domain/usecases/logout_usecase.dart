import '../entities/User.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<User> execute(String id) => repository.onLogout(id);
}
