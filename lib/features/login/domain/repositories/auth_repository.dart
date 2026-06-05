import 'package:transactional_app/features/login/domain/entities/User.dart';

abstract class AuthRepository {

  Future<User> onLogin(String email, String password);
  Future<User> onRegister(String email, String username, String password);
  Future<User> onLogout(String id);

}