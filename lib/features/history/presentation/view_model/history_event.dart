part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class SavePostToHistory extends HistoryEvent {
  final PostEntity post;

  const SavePostToHistory({required this.post});

  @override
  List<Object> get props => [post];
}

class GetHistoryPosts extends HistoryEvent {
  const GetHistoryPosts();
}

class ClearHistory extends HistoryEvent {
  const ClearHistory();
}

class RemoveFromHistory extends HistoryEvent {
  final String postId;

  const RemoveFromHistory({required this.postId});

  @override
  List<Object> get props => [postId];
}

class DeletePost extends HistoryEvent {
  final String postId;

  const DeletePost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class GetRequestedPosts extends HistoryEvent {
  const GetRequestedPosts();
}

class GetOfferedPosts extends HistoryEvent {
  const GetOfferedPosts();
}

class HistoryPostDeleted extends HistoryEvent {
  const HistoryPostDeleted();
}

class LoadHistoryPosts extends HistoryEvent {
  final List<PostEntity> posts;

  const LoadHistoryPosts({required this.posts});

  @override
  List<Object> get props => [posts];
}

class LoadHistoryError extends HistoryEvent {
  final String message;

  const LoadHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
