import '../../models/user_model.dart';

class AuthRemoteDataSource {

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: '1', email: email, username: 'Panadero', password: '');
    } else {
      throw Exception('Por favor ingresa tus credenciales');
    }
  }

  Future<UserModel> register(String email, String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      return UserModel(id: '2', email: email, username: username, password: '');
    } else {
      throw Exception('Por favor llena todos los campos');
    }
  }
}