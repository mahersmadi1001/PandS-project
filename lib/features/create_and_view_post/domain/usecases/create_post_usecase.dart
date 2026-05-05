import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/repositories/post_repository.dart';

class CreatePostUsecase {
  final PostRepository repository;
  CreatePostUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required PostEntity post,
    required File imageFile,
  }) async {
    try {
      // Upload image and get URL
      final uploadResult = await repository.uploadImage(
        imageFile: imageFile,
        postId: post.postId,
      );

      return uploadResult.fold((failure) => Left(failure), (imageUrl) async {
        // Save post with image URL
        final saveResult = await repository.createPost(
          post: post,
          imageFile: imageFile,
        );

        return saveResult.fold(
          (failure) => Left(failure),
          (_) => Right(imageUrl),
        );
      });
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
