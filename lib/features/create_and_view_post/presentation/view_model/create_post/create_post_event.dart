part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserData extends CreatePostEvent {
  const LoadUserData();
}

class CreatePostSubmitted extends CreatePostEvent {
  final String creatorId;
  final String creatorName;
  final PostType postType;
  final String category;
  final String description;
  final String province;
  final String price;
  final File imageFile;

  const CreatePostSubmitted({
    required this.creatorId,
    required this.creatorName,
    required this.postType,
    required this.category,
    required this.description,
    required this.province,
    required this.price,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [
    creatorId,
    creatorName,
    postType,
    category,
    description,
    province,
    price,
    imageFile,
  ];
}
