
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class NeuPETextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final Widget? suffixIcon;

  const NeuPETextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
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
        NeuContainer(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 15.sp,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black38,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
