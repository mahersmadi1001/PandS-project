import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:p/features/auth/presentation/view_model/Register_bloc/register_bloc.dart';
import 'package:p/features/auth/presentation/view_model/login_bloc/login_bloc.dart';
import 'package:p/features/auth/presentation/view_model/user_session/user_session_bloc.dart';
import 'package:p/features/create_and_view_post/data/datasources/post_remote_datasource.dart';
import 'package:p/features/create_and_view_post/data/repositories/post_repository_impl.dart';
import 'package:p/features/create_and_view_post/domain/repositories/post_repository.dart';
import 'package:p/features/create_and_view_post/domain/usecases/create_post_usecase.dart';
import 'package:p/features/create_and_view_post/domain/usecases/get_posts_usecase.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Profile imports ────────────────────────────────────────────────────────
import 'package:p/features/profile/domain/repositories/profile_repository.dart';
import 'package:p/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:p/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:p/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:p/features/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:p/features/profile/domain/usecases/generate_profile_link_usecase.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';

// ─── History imports ────────────────────────────────────────────────
import 'package:p/features/history/presentation/view_model/history_bloc.dart';

// ─── Theme imports ──────────────────────────────────────────────────
import 'package:p/core/presentation/bloc/theme_bloc.dart';

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
  sl.registerLazySingleton(() => Supabase.instance.client); // ← Supabase client

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
      supabase: sl(), // ← Supabase client من الـ External
    ),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton(() => CreatePostUsecase(sl()));
  sl.registerLazySingleton(() => GetPostsUsecase(sl()));

  sl.registerFactory(
    () => CreatePostBloc(
      createPostUsecase: sl(),
      getSavedSessionUsecase: sl(),
      historyBloc: sl(),
    ),
  );

  sl.registerFactory(() => GetPostsBloc(getPostsUsecase: sl()));

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ═══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => GenerateProfileLinkUseCase(sl()));

  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      uploadProfileImageUseCase: sl(),
      deleteProfileImageUseCase: sl(),
      generateProfileLinkUseCase: sl(),
    ),
  );

  // Theme
  sl.registerFactory(() => ThemeBloc());

  // History
  sl.registerFactory(
    () => HistoryBloc(
      getPostsUsecase: sl(),
      authLocalDataSource: sl(),
      firestore: sl(),
      postRepository: sl(),
    ),
  );
}
