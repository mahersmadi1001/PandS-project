import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;
  final VoidCallback? onOfferTap;

  const PostCard({Key? key, required this.post, this.onTap, this.onOfferTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 10,
      shadowColor: AppColors.primaryBlue.withAlpha(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            // Default navigation to post details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailsScreen(
                  post: post,
                  isRequest: post.postType == PostType.request,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post image at the top
            if (post.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  post.image,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 48.w,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: Icon(Icons.image, color: Colors.grey[400], size: 48.w),
              ),

            // Content below the image
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          post.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          post.price,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // User info and post type
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryBlue,
                          size: 20.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.creatorName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              post.category,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // Post type indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getPostTypeColor(),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          _getPostTypeText(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Location and time
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          post.province,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatTime(post.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Action button for requests
                  if (post.postType == PostType.request && onOfferTap != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onOfferTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Give a offer",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPostTypeColor() {
    return post.postType == PostType.request ? Colors.orange : Colors.green;
  }

  String _getPostTypeText() {
    return post.postType == PostType.request ? 'reguest' : 'offer';
  }

  String _formatTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        if (difference.inDays == 1) {
          return "Since a day";
        } else if (difference.inDays <= 7) {
          return 'Since ${difference.inDays} days';
        } else if (difference.inDays <= 30) {
          final weeks = (difference.inDays / 7).floor();
          return weeks == 1 ? 'Since a week' : 'Since $weeks weeks';
        } else {
          final months = (difference.inDays / 30).floor();
          return months == 1 ? 'Since a month' : 'Since $months months';
        }
      } else if (difference.inHours > 0) {
        if (difference.inHours == 1) {
          return 'Since an hour';
        } else {
          return 'Since ${difference.inHours} hours';
        }
      } else if (difference.inMinutes > 0) {
        if (difference.inMinutes == 1) {
          return 'Since a minute';
        } else {
          return 'Since ${difference.inMinutes} minutes';
        }
      } else {
        return 'Now';
      }
    } catch (e) {
      return createdAt;
    }
  }
}
