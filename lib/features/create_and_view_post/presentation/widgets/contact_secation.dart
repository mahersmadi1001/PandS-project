import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/contact_info.dart';

Widget contactSection({
  required BuildContext context,
  required UserEntity? userEntity,
  required PostEntity post,
  required bool isLoading,
}) {
  final userName = userEntity?.fullName ?? post.creatorName;
  final userEmail =
      userEntity?.email ?? (isLoading ? 'Loading' : 'Not available');
  final userPhone =
      userEntity?.phone ?? (isLoading ? 'Loading' : 'Not available');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'contact_section.contact_info'.tr(),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
      ),
      SizedBox(height: 12.h),
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            ContactItem(
              icon: Icons.person,
              label: 'contact_section.post_owner_name'.tr(),
              value: userName,
              onTap: () {
                copyToClipboard(
                  context,
                  userName,
                  'contact_section.name_copied'.tr(),
                );
              },
            ),
            SizedBox(height: 12.h),
            ContactItem(
              icon: Icons.email,
              label: 'auth.email'.tr(),
              value: userEmail,
              onTap: userEmail != 'Loading' && userEmail != 'Not available'
                  ? () {
                      copyToClipboard(
                        context,
                        userEmail,
                        'contact_section.email_copied'.tr(),
                      );
                    }
                  : null,
            ),
            SizedBox(height: 12.h),
            ContactItem(
              icon: Icons.phone,
              label: 'contact_section.phone_number'.tr(),
              value: userPhone,
              onTap:
                  userPhone != 'Loading' &&
                      userPhone != 'contact_section.not_available'.tr()
                  ? () {
                      copyToClipboard(
                        context,
                        userPhone,
                        'contact_section.phone_copied'.tr(),
                      );
                    }
                  : null,
            ),
            if (isLoading) ...[
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'general.loading'.tr(),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

void copyToClipboard(BuildContext context, String text, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.green),
  );
}
