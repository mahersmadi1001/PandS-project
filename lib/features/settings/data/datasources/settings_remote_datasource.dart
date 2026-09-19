import 'package:p/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsEntity?> getSettings(String userId);
  Future<void> updateSettings(SettingsEntity settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<SettingsEntity?> getSettings(String userId) async {
    // Implement remote settings fetching if needed
    // For now, returning null as remote settings are not implemented
    return null;
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    // Implement remote settings update if needed
    // For now, this is a no-op
  }
}
