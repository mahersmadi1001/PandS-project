import 'package:p/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity?> getSettings(String userId);
  Future<void> updateSettings(SettingsEntity settings);
  Future<void> logout();
}
