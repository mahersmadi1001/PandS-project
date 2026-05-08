import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register({required UserEntity user});

  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity?>> getSavedSession();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> getUserById(String userId);
}
