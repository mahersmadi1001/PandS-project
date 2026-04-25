import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/data/datasources/remote.dart';
import 'package:p/features/auth/data/repositories/repositories_implement.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';
import 'package:p/features/auth/domain/usecases/sginup_usecase.dart';
import 'package:p/features/auth/presentation/view_model/bloc/register_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => RegisterBloc(sginUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SginupUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => RepositoriesImplement(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources

  // 1. إذا كان لـ RemoteDataSources واجهة (Interface) تأكد من كتابة اسمها بين القوسين <>
  sl.registerFactory<RemoteDataSources>(
    () => RemoteDataSources(firestore: sl()),
  );

  // 2. هنا الحل الجذري: نكتب اسم الواجهة بين القوسين، واسم التنفيذ بعد السهم
  sl.registerLazySingleton<AuthLocalDataSource>(
    // لاحظ أننا حذفنا كلمة Impl من هنا
    () => AuthLocalDataSourceImpl(),
  );
  // External (Firebase & Hive)
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
}
