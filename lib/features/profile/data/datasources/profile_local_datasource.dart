import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileEntity?> getCachedProfile(String uid);
  Future<void> cacheProfile(ProfileEntity profile);
  Future<void> clearCachedProfile(String uid);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileEntity?> getCachedProfile(String uid) async {
    return null;
  }

  @override
  Future<void> cacheProfile(ProfileEntity profile) async {}

  @override
  Future<void> clearCachedProfile(String uid) async {}
}
