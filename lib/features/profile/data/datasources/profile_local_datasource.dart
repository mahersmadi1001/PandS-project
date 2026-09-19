import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileEntity?> getCachedProfile(String uid);
  Future<void> cacheProfile(ProfileEntity profile);
  Future<void> clearCachedProfile(String uid);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileEntity?> getCachedProfile(String uid) async {
    // Implement local caching if needed (e.g., using Hive or SharedPreferences)
    // For now, returning null as caching is not implemented
    return null;
  }

  @override
  Future<void> cacheProfile(ProfileEntity profile) async {
    // Implement local caching if needed
    // For now, this is a no-op
  }

  @override
  Future<void> clearCachedProfile(String uid) async {
    // Implement cache clearing if needed
    // For now, this is a no-op
  }
}
