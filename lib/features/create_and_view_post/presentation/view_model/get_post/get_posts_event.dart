part of 'get_posts_bloc.dart';

abstract class GetPostsEvent extends Equatable {
  const GetPostsEvent();
  @override
  List<Object?> get props => [];
}

class FetchPosts extends GetPostsEvent {
  final PostType? postType;
  final String? category;
  final String? searchQuery;
  final String? province;

  const FetchPosts({
    this.postType,
    this.category,
    this.searchQuery,
    this.province,
  });

  @override
  List<Object?> get props => [postType, category, searchQuery, province];
}

class RefreshPosts extends GetPostsEvent {
  final PostType? postType;
  final String? category;
  final String? searchQuery;
  final String? province;

  const RefreshPosts({
    this.postType,
    this.category,
    this.searchQuery,
    this.province,
  });

  @override
  List<Object?> get props => [postType, category, searchQuery, province];
}

class FilterPosts extends GetPostsEvent {
  final PostType? postType;
  final String? category;
  final String? province;

  const FilterPosts({
    this.postType,
    this.category,
    this.province,
  });

  @override
  List<Object?> get props => [postType, category, province];
}

class SearchPosts extends GetPostsEvent {
  final String searchQuery;

  const SearchPosts({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}
