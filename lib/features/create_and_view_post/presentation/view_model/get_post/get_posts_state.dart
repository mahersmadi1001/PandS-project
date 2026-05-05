part of 'get_posts_bloc.dart';

sealed class GetPostsState extends Equatable {
  const GetPostsState();
  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية — لم يتم جلب أي منشورات بعد
class GetPostsInitial extends GetPostsState {
  const GetPostsInitial();
}

/// جارٍ جلب المنشورات
class GetPostsLoading extends GetPostsState {
  final bool refreshing;
  
  const GetPostsLoading({this.refreshing = false});
  
  @override
  List<Object?> get props => [refreshing];
}

/// تم جلب المنشورات بنجاح
class GetPostsLoaded extends GetPostsState {
  final List<PostEntity> posts;
  final PostType? postType;
  final String? category;
  final String? searchQuery;
  final String? province;

  const GetPostsLoaded({
    required this.posts,
    this.postType,
    this.category,
    this.searchQuery,
    this.province,
  });

  @override
  List<Object?> get props => [
        posts, postType, category, searchQuery, province,
      ];
}

/// فشل جلب المنشورات
class GetPostsFailure extends GetPostsState {
  final String message;
  const GetPostsFailure({required this.message});
  
  @override
  List<Object?> get props => [message];
}
