import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transactional_app/core/network/supabase_config.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${SupabaseConfig.url}/auth/v1/token?grant_type=password'),
      headers: SupabaseConfig.headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = data['user'];
      if (user == null) throw Exception('No se encontraron datos del usuario');
      
      return UserModel(
        id: user['id'].toString(),
        email: user['email'],
        username: user['user_metadata']?['username'] ?? '',
        password: '',
      );
    } else {
      throw Exception(data['error_description'] ?? data['msg'] ?? 'Error en credenciales o no existe el usuario');
    }
  }

  Future<UserModel> register(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('${SupabaseConfig.url}/auth/v1/signup'),
      headers: SupabaseConfig.headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'data': {'username': username}
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userMap = data['user'] ?? data;
      
      if (userMap == null || userMap['id'] == null) {
        throw Exception('El registro fue exitoso pero no se recibió el ID del usuario. Verifica tu correo.');
      }

      return UserModel(
        id: userMap['id'].toString(),
        email: userMap['email'] ?? email,
        username: username,
        password: '',
      );
    } else {
      throw Exception(data['msg'] ?? data['error_description'] ?? 'Error al registrar usuario');
    }
  }
}