import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String uid;
  LoadProfile({required this.uid});
}

class UpdateProfile extends ProfileEvent {
  final ProfileEntity profile;
  UpdateProfile({required this.profile});
}

class UploadProfileImage extends ProfileEvent {
  final String uid;
  final String imagePath;
  UploadProfileImage({required this.uid, required this.imagePath});
}

class DeleteProfileImage extends ProfileEvent {
  final String uid;
  DeleteProfileImage({required this.uid});
}

class GenerateProfileLink extends ProfileEvent {
  final String uid;
  GenerateProfileLink({required this.uid});
}
