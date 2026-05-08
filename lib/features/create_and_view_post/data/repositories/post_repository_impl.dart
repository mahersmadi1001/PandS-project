import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_and_view_post/data/datasources/post_remote_datasource.dart';
import 'package:p/features/create_and_view_post/data/models/post_model.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required String postId,
  }) async {
    try {
      final String imageUrl = await remote.uploadImage(
        imageFile: imageFile,
        postId: postId,
      );
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> createPost({
    required PostEntity post,
    required File imageFile,
  }) async {
    try {
      // الخطوة ١: رفع الصورة على Supabase → جلب الـ URL
      final String imageUrl = await remote.uploadImage(
        imageFile: imageFile,
        postId: post.postId,
      );

      // الخطوة ٢: دمج الـ URL في نموذج المنشور
      final PostModel postModel = PostModel(
        postId: post.postId,
        creatorId: post.creatorId,
        creatorName: post.creatorName,
        postType: post.postType,
        category: post.category,
        title: post.title,
        description: post.description,
        province: post.province,
        price: post.price,
        image: imageUrl, // الـ URL من Supabase
        createdAt: post.createdAt,
      );

      // الخطوة ٣: حفظ المنشور في Firestore
      await remote.savePost(postModel);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    PostType? postType,
    String? category,
    String? searchQuery,
    String? province,
    String? userId,
  }) async {
    try {
      final posts = await remote.getPosts(
        postType: postType,
        category: category,
        searchQuery: searchQuery,
        province: province,
        userId: userId,
      );
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await remote.deletePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
