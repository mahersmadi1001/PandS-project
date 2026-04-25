import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uId;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  const UserEntity({
    required this.uId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [uId, email, fullName, phone, password];
}
