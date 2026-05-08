import 'package:equatable/equatable.dart';

enum PostType { request, offer }

class PostEntity extends Equatable {
  final String postId;
  final String creatorId;
  final String creatorName;
  final PostType postType;
  final String category;
  final String title;
  final String description;
  final String province;
  final String price;
  final String image; // Supabase public URL
  final String createdAt;

  const PostEntity({
    required this.postId,
    required this.creatorId,
    required this.creatorName,
    required this.postType,
    required this.category,
    required this.title,
    required this.description,
    required this.province,
    required this.price,
    required this.image,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    postId,
    creatorId,
    creatorName,
    postType,
    category,
    title,
    description,
    province,
    price,
    image,
    createdAt,
  ];

  /// Convert PostEntity to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'postType': postType.name,
      'category': category,
      'title': title,
      'description': description,
      'province': province,
      'price': price,
      'image': image,
      'createdAt': createdAt,
    };
  }

  factory PostEntity.fromMap(Map<String, dynamic> map) {
    return PostEntity(
      postId: map['postId'] ?? '',
      creatorId: map['creatorId'] ?? '',
      creatorName: map['creatorName'] ?? '',
      postType: PostType.values.firstWhere(
        (type) => type.name == map['postType'],
        orElse: () => PostType.request,
      ),
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      province: map['province'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
