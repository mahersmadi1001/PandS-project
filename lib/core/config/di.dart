import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:p/features/auth/presentation/view_model/Register_bloc/register_bloc.dart';
import 'package:p/features/auth/presentation/view_model/login_bloc/login_bloc.dart';
import 'package:p/features/auth/presentation/view_model/user_session/user_session_bloc.dart';
import 'package:p/features/create_post/data/datasources/post_remote_datasource.dart';
import 'package:p/features/create_post/data/repositories/post_repository_impl.dart';
import 'package:p/features/create_post/domain/repositories/post_repository.dart';
import 'package:p/features/create_post/domain/usecases/create_post_usecase.dart';
import 'package:p/features/create_post/presentation/view_model/create_post_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Auth imports (لا تغيير) ──────────────────────────────────────────────────
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/data/datasources/remote.dart';
import 'package:p/features/auth/data/repositories/repositories_implement.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';
import 'package:p/features/auth/domain/usecases/sginup_usecase.dart';
import 'package:p/features/auth/domain/usecases/usecase_login.dart';
import 'package:p/features/auth/domain/usecases/logout_usecase.dart';
import 'package:p/features/auth/domain/usecases/get_saved_session_usecase.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // ─── External ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Supabase.instance.client);  // ← Supabase client

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<RemoteDataSources>(
    () => RemoteDataSources(firestore: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => RepositoriesImplement(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => SginupUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetSavedSessionUsecase(sl()));

  sl.registerFactory(() => RegisterBloc(sginUseCase: sl()));
  sl.registerFactory(() => LoginBloc(loginUsecase: sl()));
  sl.registerFactory(() => UserSessionBloc(localDataSource: sl()));

  // ═══════════════════════════════════════════════════════════════════════════
  // POST
  // ═══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      firestore: sl(),
      supabase:  sl(),     // ← Supabase client من الـ External
    ),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton(() => CreatePostUsecase(sl()));

  sl.registerFactory(
    () => CreatePostBloc(createPostUsecase: sl()),
  );
}