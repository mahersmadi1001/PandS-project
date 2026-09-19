import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(String uid);
  Future<void> saveProfile(ProfileEntity profile);
  Future<String?> uploadProfileImage(String uid, String filePath);
  Future<void> deleteProfileImage(String uid);
  Future<void> updateProfile(ProfileEntity profile);
  Future<String> generateProfileLink(String uid);
}
