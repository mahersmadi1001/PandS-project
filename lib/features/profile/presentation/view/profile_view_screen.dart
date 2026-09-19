import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/profile_edit_screen.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/animated_profile_avatar.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/neu_action_button.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/staggered_fadeside.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/text_form_profile.dart';
import 'package:p/features/auth/data/datasources/local.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = _authLocalDataSource.getSession();
    if (userId != null && userId.isNotEmpty) {
      if (mounted) {
        context.read<ProfileBloc>().add(LoadProfile(uid: userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              final profile = state.profile;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "general.profile".tr(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Row(
                            children: [
                              NeuActionButton(
                                icon: Icons.refresh,
                                onTap: _loadProfile,
                              ),
                              SizedBox(width: 12.w),
                              NeuActionButton(
                                icon: Icons.edit,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen(),
                                    ),
                                  );
                                  if (result == true || mounted) {
                                    _loadProfile();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          AnimatedProfileAvatar(
                            imageUrl: profile.profileImageUrl,
                          ),
                          SizedBox(height: 16.h),
                          StaggeredFadeSlide(
                            index: 0,
                            child: Text(
                              profile.name.isNotEmpty
                                  ? profile.name
                                  : 'general.not_specified'.tr(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),

                          StaggeredFadeSlide(
                            index: 1,
                            child: NeuReadOnlyField(
                              label: "auth.email".tr(),
                              value: profile.email.isNotEmpty
                                  ? profile.email
                                  : 'general.not_specified'.tr(),
                              icon: Icons.email_outlined,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          StaggeredFadeSlide(
                            index: 2,
                            child: NeuReadOnlyField(
                              label: 'profile.phone'.tr(),
                              value: 'general.not_specified'.tr(),
                              icon: Icons.phone_outlined,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          StaggeredFadeSlide(
                            index: 3,
                            child: NeuReadOnlyField(
                              label: 'profile.bio'.tr(),
                              value: profile.bio.isNotEmpty
                                  ? profile.bio
                                  : 'profile.no_bio'.tr(),
                              icon: Icons.info_outline,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          StaggeredFadeSlide(
                            index: 4,
                            child: NeuReadOnlyField(
                              label: 'profile.skills'.tr(),
                              value: profile.skills.isNotEmpty
                                  ? profile.skills.join(', ')
                                  : 'profile.no_skills'.tr(),
                              icon: Icons.work_outline,
                            ),
                          ),

                          if (profile.profileLink.isNotEmpty) ...[
                            SizedBox(height: 20.h),
                            StaggeredFadeSlide(
                              index: 5,
                              child: NeuReadOnlyField(
                                label: 'profile.profile_link'.tr(),
                                value: profile.profileLink,
                                icon: Icons.link,
                              ),
                            ),
                          ],
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.w,
                      color: Colors.red[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'profile.profile_not_found'.tr(),
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: Text('general.retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Text(
                'profile.profile_not_found'.tr(),
                style: TextStyle(color: AppColors.primaryBlue, fontSize: 18.sp),
              ),
            );
          },
        ),
      ),
    );
  }
}
