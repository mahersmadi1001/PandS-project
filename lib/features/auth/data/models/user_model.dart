import 'package:p/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uId,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['u_id'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'u_id': uId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'trust_points': "0.0",
    };
  }
}
