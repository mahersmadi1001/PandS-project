import 'package:p/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfileUpdated extends ProfileState {}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;
  ProfileImageUploaded({required this.imageUrl});
}

class ProfileImageDeleted extends ProfileState {}

class ProfileLinkGenerated extends ProfileState {
  final String profileLink;
  ProfileLinkGenerated({required this.profileLink});
}
