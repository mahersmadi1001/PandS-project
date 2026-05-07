import 'package:dartz/dartz.dart';
import 'package:p/core/errors/failures.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/repositories/post_repository.dart';

class GetPostsUsecase {
  final PostRepository repository;

  GetPostsUsecase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({
    PostType? postType,
    String? category,
    String? searchQuery,
    String? province,
    String? userId,
  }) {
    return repository.getPosts(
      postType: postType,
      category: category,
      searchQuery: searchQuery,
      province: province,
      userId: userId,
    );
  }
}
