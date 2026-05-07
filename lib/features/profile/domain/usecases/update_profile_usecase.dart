import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:p/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> call(ProfileEntity profile) async {
    return await _repository.updateProfile(profile);
  }
}
