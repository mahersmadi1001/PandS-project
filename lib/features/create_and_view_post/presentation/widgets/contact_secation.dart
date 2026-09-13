import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // تمت الإضافة لدعم النسخ الفعلي للحافظة
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/theme/neumorphic_styles.dart'; // استيراد النمط النيومورفي
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
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      SizedBox(height: 12.h),
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: NeumorphicStyles.getDecoration(context, borderRadius: 16.r),
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
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'general.loading'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
  Clipboard.setData(ClipboardData(text: text));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      duration: const Duration(seconds: 2),
    ),
  );
}
