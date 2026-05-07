import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:p/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:p/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:p/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:p/features/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:p/features/profile/domain/usecases/generate_profile_link_usecase.dart';

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

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final DeleteProfileImageUseCase _deleteProfileImageUseCase;
  final GenerateProfileLinkUseCase _generateProfileLinkUseCase;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required DeleteProfileImageUseCase deleteProfileImageUseCase,
    required GenerateProfileLinkUseCase generateProfileLinkUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _uploadProfileImageUseCase = uploadProfileImageUseCase,
       _deleteProfileImageUseCase = deleteProfileImageUseCase,
       _generateProfileLinkUseCase = generateProfileLinkUseCase,
       super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<DeleteProfileImage>(_onDeleteProfileImage);
    on<GenerateProfileLink>(_onGenerateProfileLink);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await _getProfileUseCase(event.uid);
      if (profile != null) {
        emit(ProfileLoaded(profile: profile!));
      } else {
        emit(ProfileError(message: 'Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _updateProfileUseCase(event.profile);
      emit(ProfileUpdated());
      // Reload profile to get updated data
      add(LoadProfile(uid: event.profile.uid));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUploadProfileImage(UploadProfileImage event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final imageUrl = await _uploadProfileImageUseCase(event.uid, event.imagePath);
      if (imageUrl != null) {
        emit(ProfileImageUploaded(imageUrl: imageUrl));
        // Reload profile to get updated data
        add(LoadProfile(uid: event.uid));
      } else {
        emit(ProfileError(message: 'Failed to upload profile image'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProfileImage(DeleteProfileImage event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _deleteProfileImageUseCase(event.uid);
      emit(ProfileImageDeleted());
      // Reload profile to get updated data
      add(LoadProfile(uid: event.uid));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onGenerateProfileLink(GenerateProfileLink event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profileLink = await _generateProfileLinkUseCase(event.uid);
      emit(ProfileLinkGenerated(profileLink: profileLink));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
