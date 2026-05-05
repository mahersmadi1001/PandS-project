import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/features/create_and_view_post/data/models/post_model.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PostRemoteDataSource {
  Future<String> uploadImage({required File imageFile, required String postId});

  Future<void> savePost(PostModel post);

  Future<List<PostEntity>> getPosts({
    PostType? postType,
    String? category,
    String? searchQuery,
    String? province,
  });
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;
  final SupabaseClient supabase;

  static const String _bucket = 'posts';
  static const String _collection = 'posts';
  static const Duration _timeout = Duration(seconds: 15);

  PostRemoteDataSourceImpl({required this.firestore, required this.supabase});

  @override
  Future<String> uploadImage({
    required File imageFile,
    required String postId,
  }) async {
    try {
      final String path = 'posts/$postId/image.jpg';

      await supabase.storage
          .from(_bucket)
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      final String publicUrl = supabase.storage
          .from(_bucket)
          .getPublicUrl(path);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('فشل رفع الصورة: ${e.message}');
    } catch (e) {
      throw Exception('لا يوجد اتصال بالإنترنت أثناء رفع الصورة');
    }
  }

  // ─── حفظ المنشور في Firestore ─────────────────────────────────────────────
  // الـ document ID = post_id (UUID) — مطابق لما يظهر في Firebase Console
  @override
  Future<void> savePost(PostModel post) async {
    try {
      await firestore
          .collection(_collection)
          .doc(post.postId) // post_id يكون هو الـ document ID
          .set(post.toMap())
          .timeout(_timeout);
    } on FirebaseException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } on Exception {
      throw Exception('لا يوجد اتصال بالإنترنت، أعد المحاولة');
    }
  }

  // ─── جلب المنشورات من Firestore ─────────────────────────────────────────────
  @override
  Future<List<PostEntity>> getPosts({
    PostType? postType,
    String? category,
    String? searchQuery,
    String? province,
  }) async {
    try {
      Query query = firestore.collection(_collection);

      // ترتيب حسب تاريخ الإنشاء (الأحدث أولاً) - يجب أن يكون أول عملية
      query = query.orderBy('created_at', descending: true);

      // تطبيق الفلاتر
      if (postType != null) {
        query = query.where('post_type', isEqualTo: postType.name);
      }
      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      if (province != null && province.isNotEmpty) {
        query = query.where('province', isEqualTo: province);
      }

      final QuerySnapshot snapshot = await query
          .limit(100)
          .get()
          .timeout(_timeout);

      final List<PostEntity> posts = snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // تطبيق البحث النصي إذا كان موجود
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final filteredPosts = posts.where((post) {
          final query = searchQuery.toLowerCase();
          return post.description.toLowerCase().contains(query) ||
              post.category.toLowerCase().contains(query) ||
              post.province.toLowerCase().contains(query) ||
              post.creatorName.toLowerCase().contains(query);
        }).toList();
        return filteredPosts;
      }

      return posts;
    } on FirebaseException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } catch (e) {
      throw Exception('خطأ في جلب المنشورات: $e');
    }
  }

  // ─── ترجمة أخطاء Firebase ─────────────────────────────────────────────────
  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        return 'لا يوجد اتصال بالإنترنت';
      case 'permission-denied':
        return 'ليس لديك صلاحية';
      case 'deadline-exceeded':
        return 'انتهت مهلة الاتصال، أعد المحاولة';
      default:
        return 'حدث خطأ: ${e.message ?? e.code}';
    }
  }
}
