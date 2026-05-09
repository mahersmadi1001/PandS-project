import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
import 'package:p/core/presentation/view_model/theme_bloc.dart';

// ─── Language imports ──────────────────────────────────────────────────
import 'package:p/core/services/language_service.dart';
import 'package:p/core/presentation/view_model/language_cubit.dart';

// ─── Auth imports (لا تغيير) ──────────────────────────────────────────────────
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/data/datasources/remote.dart';
import 'package:p/features/auth/data/repositories/repositories_implement.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';
import 'package:p/features/auth/domain/usecases/sginup_usecase.dart';
import 'package:p/features/auth/domain/usecases/usecase_login.dart';
import 'package:p/features/auth/domain/usecases/logout_usecase.dart';
import 'package:p/features/auth/domain/usecases/get_saved_session_usecase.dart';

final di = GetIt.instance;

Future<void> setup() async {
  // ─── External ──────────────────────────────────────────────────────────────
  di.registerLazySingleton(() => FirebaseFirestore.instance);
  di.registerLazySingleton(() => Supabase.instance.client); // ← Supabase client
  di.registerLazySingleton(() => InternetConnectionChecker.instance);

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  di.registerLazySingleton<RemoteDataSources>(
    () => RemoteDataSources(firestore: di(), connectionChecker: di()),
  );
  di.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  di.registerLazySingleton<AuthRepository>(
    () => RepositoriesImplement(remoteDataSource: di(), localDataSource: di()),
  );
  di.registerLazySingleton(() => SginupUsecase(repository: di()));
  di.registerLazySingleton(() => LoginUsecase(repository: di()));
  di.registerLazySingleton(() => LogoutUsecase(di()));
  di.registerLazySingleton(() => GetSavedSessionUsecase(di()));

  di.registerLazySingleton(() => RegisterBloc(sginUseCase: di()));
  di.registerFactory(() => LoginBloc(loginUsecase: di()));
  di.registerFactory(() => UserSessionBloc(localDataSource: di()));

  // ═══════════════════════════════════════════════════════════════════════════
  // POST
  // ═══════════════════════════════════════════════════════════════════════════

  di.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      firestore: di(),
      supabase: di(), // ← Supabase client من الـ External
    ),
  );
  di.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: di()),
  );
  di.registerLazySingleton(() => CreatePostUsecase(di()));
  di.registerLazySingleton(() => GetPostsUsecase(di()));

  di.registerFactory(
    () => CreatePostBloc(
      createPostUsecase: di(),
      getSavedSessionUsecase: di(),
      historyBloc: di(),
    ),
  );

  di.registerFactory(() => GetPostsBloc(getPostsUsecase: di()));

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ═══════════════════════════════════════════════════════════════════════════

  di.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  di.registerLazySingleton(() => GetProfileUseCase(di()));
  di.registerLazySingleton(() => UpdateProfileUseCase(di()));
  di.registerLazySingleton(() => UploadProfileImageUseCase(di()));
  di.registerLazySingleton(() => DeleteProfileImageUseCase(di()));
  di.registerLazySingleton(() => GenerateProfileLinkUseCase(di()));

  di.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: di(),
      updateProfileUseCase: di(),
      uploadProfileImageUseCase: di(),
      deleteProfileImageUseCase: di(),
      generateProfileLinkUseCase: di(),
    ),
  );

  // Theme
  di.registerFactory(() => ThemeBloc());

  // Language
  di.registerFactory(() => LanguageCubit());

  // History
  di.registerFactory(
    () => HistoryBloc(
      getPostsUsecase: di(),
      authLocalDataSource: di(),
      firestore: di(),
      postRepository: di(),
    ),
  );
}
