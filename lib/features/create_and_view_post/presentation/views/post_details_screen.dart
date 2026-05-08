import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/plas_holder_image.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';
import 'package:get_it/get_it.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/contact_info.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/contact_secation.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/detai_item.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/detail_section.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostEntity post;
  final bool isRequest;

  const PostDetailsScreen({
    Key? key,
    required this.post,
    required this.isRequest,
  }) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  UserEntity? userEntity;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authRepository = GetIt.instance<AuthRepository>();
      final result = await authRepository.getUserById(widget.post.creatorId);

      result.fold(
        (failure) {
          // Handle error - keep using existing data
          print('Error fetching user data: $failure');
        },
        (user) {
          setState(() {
            userEntity = user;
          });
        },
      );
    } catch (e) {
      // Handle error
      print('Exception fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.post.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                      child: Image.network(
                        widget.post.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return PlasHolder();
                        },
                      ),
                    )
                  else
                    PlasHolder(),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${widget.post.price} \$",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DetailSection(
                    title: "",
                    children: [
                      DetailItem(
                        label: "Description",
                        value: widget.post.description,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // User info
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.primaryBlue.withOpacity(
                            0.1,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primaryBlue,
                            size: 30.w,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.creatorName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.post.category,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Details section
                  DetailSection(
                    title: 'Details',
                    children: [
                      DetailItem(
                        label: 'Category',
                        value: widget.post.category,
                      ),
                      DetailItem(
                        label: 'Province',
                        value: widget.post.province,
                      ),
                      DetailItem(label: 'Price', value: widget.post.price),
                      DetailItem(
                        label: 'Type',
                        value: widget.isRequest ? 'Request' : 'Offer',
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Contact section
                  contactSection(
                    context: context,
                    isLoading: isLoading,
                    userEntity: userEntity,
                    post: widget.post,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
