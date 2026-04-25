import 'package:dartz/dartz.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, void>> register({required UserEntity user});
  Future<Either<Failure, UserEntity?>> getSavedSession();
  Future<void> logout();
}
