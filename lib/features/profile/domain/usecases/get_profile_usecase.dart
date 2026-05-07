import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:p/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<ProfileEntity?> call(String uid) async {
    return await _repository.getProfile(uid);
  }
}
