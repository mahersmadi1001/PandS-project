import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_post/domain/entities/post_entity.dart';


abstract class PostRepository {
  /// رفع الصورة على Supabase وحفظ بيانات المنشور في Firestore
  Future<Either<Failure, void>> createPost({
    required PostEntity post,
    required File imageFile,
  });
}
