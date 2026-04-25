// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:p/core/errors/failures.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/data/datasources/remote.dart';
import 'package:p/features/auth/data/models/user_model.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';

class RepositoriesImplement implements AuthRepository {
  final RemoteDataSources remoteDataSource;
  final AuthLocalDataSource localDataSource;
  RepositoriesImplement({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, UserEntity?>> getSavedSession() {
    // TODO: implement getSavedSession
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> register({required UserEntity user}) async {
    try {
      final UserModel userModle = UserModel(
        uId: user.uId,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: user.password,
      );
      await remoteDataSource.register(user: userModle);
      await localDataSource.saveUserSession(user.uId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
