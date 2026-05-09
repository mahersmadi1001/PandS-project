import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p/features/auth/data/models/user_model.dart';
import 'package:p/features/auth/domain/entities/user.dart';

class RemoteDataSources {
  final FirebaseFirestore firestore;
  final InternetConnectionChecker connectionChecker;
  static const String _collection = 'users';

  static const Duration _timeout = Duration(seconds: 10);

  RemoteDataSources({required this.firestore, required this.connectionChecker});

  Future<UserEntity> register({required UserModel user}) async {
    try {
      // Check internet connection first
      final hasConnection = await connectionChecker.hasConnection;
      if (!hasConnection) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }

      final existing = await firestore
          .collection(_collection)
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get()
          .timeout(_timeout);

      if (existing.docs.isNotEmpty) {
        throw Exception('هذا البريد الإلكتروني مسجل مسبقاً');
      }

      await firestore
          .collection(_collection)
          .doc(user.uId)
          .set(user.toMap())
          .timeout(_timeout);

      return user;
    } on FirebaseException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network') ||
          e.toString().contains('Internet')) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check internet connection first
      final hasConnection = await connectionChecker.hasConnection;
      if (!hasConnection) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }

      final result = await firestore
          .collection(_collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get()
          .timeout(_timeout);

      if (result.docs.isEmpty) {
        throw Exception('البريد الإلكتروني غير موجود');
      }

      final data = result.docs.first.data();

      if (data['password'] != password) {
        throw Exception('كلمة المرور غير صحيحة');
      }

      return UserModel.fromMap(data);
    } on FirebaseException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network') ||
          e.toString().contains('Internet')) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<UserEntity?> getUserById(String uId) async {
    try {
      // Check internet connection first
      final hasConnection = await connectionChecker.hasConnection;
      if (!hasConnection) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }

      final doc = await firestore
          .collection(_collection)
          .doc(uId)
          .get()
          .timeout(_timeout);

      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network') ||
          e.toString().contains('Internet')) {
        throw Exception(
          'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة',
        );
      }
      throw Exception('حدث خطأ: ${e.toString()}');
    }
  }

  Future<void> logout() async {}

  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        return 'لا يوجد اتصال بالإنترنت، تحقق من اتصالك وأعد المحاولة';
      case 'permission-denied':
        return 'ليس لديك صلاحية، تواصل مع المطوّر';
      case 'deadline-exceeded':
        return 'انتهت مهلة الاتصال، أعد المحاولة';
      case 'not-found':
        return 'البيانات غير موجودة';
      default:
        return 'حدث خطأ: ${e.message ?? e.code}';
    }
  }
}
