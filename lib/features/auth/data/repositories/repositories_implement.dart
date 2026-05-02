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
  Future<Either<Failure, void>> register({required UserEntity user}) async {
    try {
      final model = UserModel(
        uId: user.uId,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: user.password,
      );
      await remoteDataSource.register(user: model);
      await localDataSource.saveSession(user.uId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveSession(user.uId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getSavedSession() async {
    try {
      if (!localDataSource.hasSession()) return const Right(null);
      final uId = localDataSource.getSession()!;
      final user = await remoteDataSource.getUserById(uId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}