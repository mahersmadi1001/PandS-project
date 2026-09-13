import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/plas_holder_image.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/repositories/auth_reposatory.dart';
import 'package:get_it/get_it.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/contact_secation.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/detai_item.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/detail_section.dart';
import 'package:p/core/theme/neumorphic_styles.dart';

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

      result.fold((failure) {}, (user) {
        setState(() {
          userEntity = user;
        });
      });
    } catch (e) {
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
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.shadowDarkBottom
                          : AppColors.shadowLightBottom,
                      offset: const Offset(0, 10),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                  child: widget.post.image.isNotEmpty
                      ? Image.network(
                          widget.post.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              PlasHolder(),
                        )
                      : PlasHolder(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: NeumorphicStyles.getDecoration(
                          context,
                          borderRadius: 16.r,
                        ),
                        child: Text(
                          "${widget.post.price} \$",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  DetailSection(
                    title: "",
                    children: [
                      DetailItem(
                        label: "post_details.description".tr(),
                        value: widget.post.description,
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: NeumorphicStyles.getDecoration(
                      context,
                      borderRadius: 20.r,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: NeumorphicStyles.getDecoration(
                            context,
                            isCircle: true,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.creatorName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.post.category,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: NeumorphicStyles.getDecoration(
                      context,
                      borderRadius: 20.r,
                    ),
                    child: DetailSection(
                      title: 'post_details.details'.tr(),
                      children: [
                        DetailItem(
                          label: 'post_details.category'.tr(),
                          value: widget.post.category,
                        ),
                        DetailItem(
                          label: 'post_details.province'.tr(),
                          value: widget.post.province,
                        ),
                        DetailItem(
                          label: 'post_details.price'.tr(),
                          value: widget.post.price,
                        ),
                        DetailItem(
                          label: 'post_details.type'.tr(),
                          value: widget.isRequest
                              ? 'post_details.request'.tr()
                              : 'post_details.offer'.tr(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  contactSection(
                    context: context,
                    isLoading: isLoading,
                    userEntity: userEntity,
                    post: widget.post,
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
