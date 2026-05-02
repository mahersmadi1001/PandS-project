import 'package:p/features/create_post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.postId,
    required super.creatorId,
    required super.creatorName,
    required super.postType,
    required super.category,
    required super.description,
    required super.province,
    required super.price,
    required super.image,
    required super.createdAt,
  });

  // ── تحويل من Entity إلى Map لحفظه في Firestore ─────────────────────────────
  // الحقول مطابقة لما يظهر في Firebase Console
  Map<String, dynamic> toMap() {
    return {
      'post_id':      postId,
      'creator_id':   creatorId,
      'creator_name': creatorName,
      'post_type':    postType.name,   // 'request' | 'offer'
      'category':     category,
      'description':  description,
      'province':     province,
      'price':        price,
      'image':        image,           // Supabase public URL
      'created_at':   createdAt,
    };
  }

  // ── تحويل من Firestore إلى Model ────────────────────────────────────────────
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId:      map['post_id']      as String? ?? '',
      creatorId:   map['creator_id']   as String? ?? '',
      creatorName: map['creator_name'] as String? ?? '',
      postType:    _parseType(map['post_type']),
      category:    map['category']     as String? ?? '',
      description: map['description']  as String? ?? '',
      province:    map['province']     as String? ?? '',
      price:       map['price']        as String? ?? '',
      image:       map['image']        as String? ?? '',
      createdAt:   map['created_at']   as String? ?? '',
    );
  }

  static PostType _parseType(dynamic val) {
    if (val == 'offer') return PostType.offer;
    return PostType.request; // default
  }

  // ── نسخ مع تعديل (مفيد عند رفع الصورة وتحديث الـ URL) ───────────────────────
  PostModel copyWith({ String? image }) {
    return PostModel(
      postId:      postId,
      creatorId:   creatorId,
      creatorName: creatorName,
      postType:    postType,
      category:    category,
      description: description,
      province:    province,
      price:       price,
      image:       image ?? this.image,
      createdAt:   createdAt,
    );
  }
}
