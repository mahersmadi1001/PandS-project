import 'package:p/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsEntity?> getCachedSettings(String userId);
  Future<void> cacheSettings(SettingsEntity settings);
  Future<void> clearSession();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<SettingsEntity?> getCachedSettings(String userId) async {
    // Implement local caching if needed (e.g., using Hive or SharedPreferences)
    // For now, returning null as caching is not implemented
    return null;
  }

  @override
  Future<void> cacheSettings(SettingsEntity settings) async {
    // Implement local caching if needed
    // For now, this is a no-op
  }

  @override
  Future<void> clearSession() async {
    // Implement session clearing
    // For now, this is a no-op
  }
}
