
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class PostWidgetHome extends StatelessWidget {
  const PostWidgetHome({
    super.key,
    required this.category,
    required this.categoryPosts,
  });

  final String category;
  final List<PostEntity> categoryPosts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        // Category header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        // Posts in this category
        ...categoryPosts.map(
          (post) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: PostCard(
              post: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PostDetailsScreen(post: post, isRequest: false),
                  ),
                );
              },
              onOfferTap: null, // No offer button for offers
            ),
          ),
        ),
      ],
    );
  }
}
