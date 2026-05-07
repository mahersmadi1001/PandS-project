import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

abstract class PostRepository {
  /// رفع الصورة على Supabase وحفظ بيانات المنشور في Firestore
  Future<Either<Failure, void>> createPost({
    required PostEntity post,
    required File imageFile,
  });

  /// رفع الصورة على Supabase فقط
  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required String postId,
  });

  /// جلب المنشورات من Firestore مع إمكانية التصفية
  Future<Either<Failure, List<PostEntity>>> getPosts({
    PostType? postType,
    String? category,
    String? searchQuery,
    String? province,
    String? userId,
  });

  /// حذف منشور معين من Firestore
  Future<Either<Failure, void>> deletePost(String postId);
}
