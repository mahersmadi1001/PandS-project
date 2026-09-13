import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/shared/widgets/post_card/image_post.dart';
import 'package:p/core/shared/widgets/post_card/post_card_fun.dart';
import 'package:p/core/shared/widgets/post_card/post_user_info.dart';
import 'package:p/core/theme/neumorphic_styles.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: NeumorphicStyles.getDecoration(context, borderRadius: 16.r),
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
                if (post.image.isNotEmpty)
                  ImagePost(post: post)
                else
                  Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 64.w,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.w),
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
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: NeumorphicStyles.getDecoration(context, borderRadius: 12.r),
                            child: Text(
                              "${post.price} \$",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      PostUserInfo(post: post),
                      SizedBox(height: 20.h),
                      Row(
                        textDirection: Directionality.of(context),
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              post.province,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.access_time,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              PostCardFun.formatTime(
                                createdAt: post.createdAt,
                                context: context,
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      if (post.postType == PostType.request && onOfferTap != null)
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: GestureDetector(
                            onTap: onOfferTap,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: NeumorphicStyles.getDecoration(context, borderRadius: 12.r),
                              alignment: Alignment.center,
                              child: Text(
                                "post_card.give_offer".tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
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
              top: 12.h,
              right: 12.w,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: NeumorphicStyles.getDecoration(context, isCircle: true),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}