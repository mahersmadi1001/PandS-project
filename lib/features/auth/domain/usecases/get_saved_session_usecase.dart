import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';

class GetSavedSessionUsecase {
  final AuthRepository repository;
  GetSavedSessionUsecase(this.repository);

  Future<Either<Failure, UserEntity?>> call() {
    return repository.getSavedSession();
  }
}