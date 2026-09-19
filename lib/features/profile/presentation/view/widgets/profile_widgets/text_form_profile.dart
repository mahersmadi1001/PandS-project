import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class NeuReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const NeuReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NeuContainer(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.black12 : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}