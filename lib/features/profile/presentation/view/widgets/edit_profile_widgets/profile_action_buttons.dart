import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_button_ef.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/staggered_fadeside.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onUploadImage;
  final VoidCallback onSaveProfile;
  final bool hasSelectedImage;
  final bool isUploading;

  const ProfileActionButtons({
    super.key,
    required this.onPickImage,
    required this.onUploadImage,
    required this.onSaveProfile,
    required this.hasSelectedImage,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StaggeredFadeSlide(
          index: 6,
          child: Row(
            children: [
              Expanded(
                child: NeuButton(
                  text: 'profile.choose_image'.tr(),
                  onPressed: onPickImage,
                  isPrimary: false,
                ),
              ),
              if (hasSelectedImage) ...[
                SizedBox(width: 16.w),
                Expanded(
                  child: NeuButton(
                    text: 'profile.upload_image'.tr(),
                    onPressed: onUploadImage,
                    isLoading: isUploading,
                    isPrimary: true,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 20.h),
        StaggeredFadeSlide(
          index: 7,
          child: NeuButton(
            text: 'profile.save_changes'.tr(),
            onPressed: onSaveProfile,
            isPrimary: true,
            isFullWidth: true,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
