import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_post/domain/entities/post_entity.dart';
import 'package:p/features/create_post/domain/repositories/post_repository.dart';


class CreatePostUsecase {
  final PostRepository repository;
  CreatePostUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required PostEntity post,
    required File imageFile,
  }) {
    return repository.createPost(post: post, imageFile: imageFile);
  }
}
