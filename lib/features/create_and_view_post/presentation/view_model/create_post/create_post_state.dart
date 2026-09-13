part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();
  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}

class CreatePostLoadingUser extends CreatePostState {
  const CreatePostLoadingUser();
}

class CreatePostUserLoaded extends CreatePostState {
  final String userId;
  final String userName;
  const CreatePostUserLoaded({required this.userId, required this.userName});
  @override
  List<Object?> get props => [userId, userName];
}

class CreatePostUploadingImage extends CreatePostState {
  const CreatePostUploadingImage();
}

class CreatePostSaving extends CreatePostState {
  const CreatePostSaving();
}

class CreatePostSuccess extends CreatePostState {
  final PostEntity post;
  const CreatePostSuccess({required this.post});

  @override
  List<Object?> get props => [post];
}

class CreatePostFailure extends CreatePostState {
  final String message;
  const CreatePostFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
