import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserSession(String uId);
  String? getUserSession();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box authBox = Hive.box('auth_box');

  @override
  Future<void> saveUserSession(String uId) async {
    await authBox.put('u_id', uId);
  }

  @override
  String? getUserSession() {
    return authBox.get('u_id');
  }

  @override
  Future<void> clearSession() async {
    await authBox.delete('u_id');
  }
}