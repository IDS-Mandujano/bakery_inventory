import '../../domain/entities/User.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      username: json['username'] ?? '',
      password: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }
}