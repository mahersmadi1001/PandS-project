import 'package:p/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:p/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:p/features/settings/domain/entities/settings_entity.dart';
import 'package:p/features/settings/domain/repositories/settings_repository.dart';
import 'package:p/features/auth/data/datasources/local.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<SettingsEntity?> getSettings(String userId) async {
    try {
      final cachedSettings = await localDataSource.getCachedSettings(userId);
      if (cachedSettings != null) {
        return cachedSettings;
      }

      final settings = await remoteDataSource.getSettings(userId);
      if (settings != null) {
        await localDataSource.cacheSettings(settings);
      }
      return settings;
    } catch (e) {
      print('Error getting settings: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    try {
      await remoteDataSource.updateSettings(settings);
      await localDataSource.cacheSettings(settings);
    } catch (e) {
      print('Error updating settings: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authLocalDataSource.clearSession();
      await localDataSource.clearSession();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
