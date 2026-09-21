import 'package:p/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsEntity?> getCachedSettings(String userId);
  Future<void> cacheSettings(SettingsEntity settings);
  Future<void> clearSession();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<SettingsEntity?> getCachedSettings(String userId) async {
    return null;
  }

  @override
  Future<void> cacheSettings(SettingsEntity settings) async {}

  @override
  Future<void> clearSession() async {}
}
