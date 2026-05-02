import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';

class SginupUsecase {
  final AuthRepository repository;
  SginupUsecase({required this.repository});

  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.register(user: user);
  }
}