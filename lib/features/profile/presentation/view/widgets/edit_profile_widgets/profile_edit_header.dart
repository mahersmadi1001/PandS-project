import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/neu_action_button.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileEditHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const ProfileEditHeader({
    super.key,
    required this.onBackPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeuActionButton(
            icon: Icons.arrow_back_ios_new,
            onTap: onBackPressed,
          ),
          Text(
            'profile.personal_profile'.tr(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          NeuActionButton(
            icon: Icons.share,
            onTap: onSharePressed,
          ),
        ],
      ),
    );
  }
}
