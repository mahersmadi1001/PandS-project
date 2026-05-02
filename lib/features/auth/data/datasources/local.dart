import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(String uId);
  String? getSession();
  Future<void> clearSession();
  bool hasSession();
  bool isFirstTimeOpen();
  Future<void> completeOnboarding();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _boxName = 'auth_box';
  static const String _keyUid = 'u_id';
  static const String _keyOnboard = 'onboarding_done';

  Box get _box => Hive.box(_boxName);

  @override
  Future<void> saveSession(String uId) async {
    await _box.put(_keyUid, uId);
  }

  @override
  String? getSession() => _box.get(_keyUid) as String?;

  @override
  Future<void> clearSession() async {
    await _box.delete(_keyUid);
  }

  @override
  bool hasSession() {
    final val = _box.get(_keyUid);
    return val != null && (val as String).isNotEmpty;
  }

  @override
  bool isFirstTimeOpen() {
    final done = _box.get(_keyOnboard) as bool?;
    return done != true;
  }

  @override
  Future<void> completeOnboarding() async {
    await _box.put(_keyOnboard, true);
  }
}
