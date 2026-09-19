import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/core/shared/widgets/plas_holder_image.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/post_detalis_widgets/contact_secation.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/post_detalis_widgets/detai_item.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/post_detalis_widgets/detail_section.dart';
import 'package:p/core/theme/neumorphic_styles.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/post_detalis_widgets/creator_info.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile(uid: widget.post.creatorId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          UserEntity? userEntity;
          bool isLoading = false;

          if (state is ProfileLoading) {
            isLoading = true;
          } else if (state is ProfileLoaded) {
           
            userEntity = UserEntity(
              uId: state.profile.uid,
              fullName: state.profile.name,
              email: state.profile.email,
              phone: '', 
              password: '', 
            ); 
          }

          return CustomScrollView(
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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

                      CaeatorInfo(
                        category: widget.post.category,
                        creatorName: widget.post.creatorName,
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

                      ContactSection(
                        userPhone: userEntity?.phone ?? "",
                        isLoading: isLoading,
                        userEmail: userEntity?.email ?? "",
                        userName: userEntity?.fullName ?? "",
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
