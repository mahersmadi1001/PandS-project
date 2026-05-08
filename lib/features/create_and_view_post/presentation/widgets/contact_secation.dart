import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  // Get real user data or fallback to post data
  final userName = userEntity?.fullName ?? post.creatorName;
  final userEmail =
      userEntity?.email ?? (isLoading ? 'Loading' : 'Not available');
  final userPhone =
      userEntity?.phone ?? (isLoading ? 'Loading' : 'Not available');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'معلومات التواصل',
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
              label: 'Name of the post owner',
              value: userName,
              onTap: () {
                copyToClipboard(context, userName, 'تم نسخ الاسم');
              },
            ),
            SizedBox(height: 12.h),
            ContactItem(
              icon: Icons.email,
              label: 'Email',
              value: userEmail,
              onTap: userEmail != 'Loading' && userEmail != 'Not available'
                  ? () {
                      copyToClipboard(
                        context,
                        userEmail,
                        'تم نسخ البريد الإلكتروني',
                      );
                    }
                  : null,
            ),
            SizedBox(height: 12.h),
            ContactItem(
              icon: Icons.phone,
              label: 'رقم الهاتف',
              value: userPhone,
              onTap: userPhone != 'Loading' && userPhone != 'غير متوفر'
                  ? () {
                      copyToClipboard(context, userPhone, 'تم نسخ رقم الهاتف');
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
                    'Loading contact information...',
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
