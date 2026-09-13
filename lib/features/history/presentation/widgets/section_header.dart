import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/neumorphic_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.context, required this.title});

  final BuildContext context;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: NeumorphicStyles.getDecoration(context, borderRadius: 16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.tune_rounded,
              size: 20.w,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
