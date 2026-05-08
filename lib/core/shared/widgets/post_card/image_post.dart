import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class ImagePost extends StatelessWidget {
  const ImagePost({super.key, required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Image.network(
        post.image,
        width: double.infinity,
        height: 120.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Placeholder();
        },
      ),
    );
  }
}
