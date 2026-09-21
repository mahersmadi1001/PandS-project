import 'package:p/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsEntity?> getSettings(String userId);
  Future<void> updateSettings(SettingsEntity settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  @override
  Future<SettingsEntity?> getSettings(String userId) async {
    return null;
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {}
}
