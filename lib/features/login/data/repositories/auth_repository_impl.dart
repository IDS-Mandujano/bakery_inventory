import '../../domain/entities/User.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> onLogin(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User> onRegister(String email, String username, String password) async {
    return await remoteDataSource.register(email, username, password);
  }

  @override
  Future<User> onLogout(String id) {
    throw UnimplementedError();
  }
}