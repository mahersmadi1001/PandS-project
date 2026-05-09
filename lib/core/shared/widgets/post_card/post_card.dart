import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/shared/widgets/post_card/image_post.dart';
import 'package:p/core/shared/widgets/post_card/post_card_fun.dart';
import 'package:p/core/shared/widgets/post_card/post_user_info.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;
  final VoidCallback? onOfferTap;
  final VoidCallback? onDelete;

  const PostCard({
    Key? key,
    required this.post,
    this.onTap,
    this.onOfferTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      elevation: 10,
      shadowColor: AppColors.primaryBlue.withAlpha(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
              } else {
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
              textDirection: Directionality.of(context),
              children: [
                // Post image at top
                if (post.image.isNotEmpty)
                  ImagePost(post: post)
                else
                  Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[600],
                      size: 64.w,
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: Directionality.of(context),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: Directionality.of(context),
                        children: [
                          Expanded(
                            child: Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

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
                              "${post.price} \$",

                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      PostUserInfo(post: post),

                      SizedBox(height: 12.h),

                      Row(
                        textDirection: Directionality.of(context),
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
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              PostCardFun.formatTime(createdAt: post.createdAt),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),

                      if (post.postType == PostType.request &&
                          onOfferTap != null)
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
                                "post_card.give_offer".tr(),
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

          if (onDelete != null)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white, size: 20.w),
                  onPressed: onDelete,
                  padding: EdgeInsets.all(4.w),
                  constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
