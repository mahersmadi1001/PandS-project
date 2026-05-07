import 'package:p/features/profile/domain/repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  final ProfileRepository _repository;

  UploadProfileImageUseCase(this._repository);

  Future<String?> call(String uid, String filePath) async {
    return await _repository.uploadProfileImage(uid, filePath);
  }
}
