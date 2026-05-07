import 'package:p/features/profile/domain/repositories/profile_repository.dart';

class DeleteProfileImageUseCase {
  final ProfileRepository _repository;

  DeleteProfileImageUseCase(this._repository);

  Future<void> call(String uid) async {
    return await _repository.deleteProfileImage(uid);
  }
}
