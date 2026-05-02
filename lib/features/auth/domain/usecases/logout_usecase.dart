import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';

class LogoutUsecase {
  final AuthRepository repository;
  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}