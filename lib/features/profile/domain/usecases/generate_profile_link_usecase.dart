import 'package:p/features/profile/domain/repositories/profile_repository.dart';

class GenerateProfileLinkUseCase {
  final ProfileRepository _repository;

  GenerateProfileLinkUseCase(this._repository);

  Future<String> call(String uid) async {
    return await _repository.generateProfileLink(uid);
  }
}
