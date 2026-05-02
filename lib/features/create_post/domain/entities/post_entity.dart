import 'package:equatable/equatable.dart';

enum PostType { request, offer }

class PostEntity extends Equatable {
  final String   postId;
  final String   creatorId;
  final String   creatorName;
  final PostType postType;
  final String   category;
  final String   description;
  final String   province;
  final String   price;
  final String   image;       // Supabase public URL
  final String   createdAt;

  const PostEntity({
    required this.postId,
    required this.creatorId,
    required this.creatorName,
    required this.postType,
    required this.category,
    required this.description,
    required this.province,
    required this.price,
    required this.image,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        postId, creatorId, creatorName, postType,
        category, description, province, price, image, createdAt,
      ];
}
