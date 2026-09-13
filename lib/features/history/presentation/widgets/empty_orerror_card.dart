
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/neumorphic_styles.dart';

class EmptyOrErrorCard extends StatelessWidget {
  const EmptyOrErrorCard({
    super.key,
    required this.context,
    required this.message,
  });

  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: NeumorphicStyles.getDecoration(context, borderRadius: 20.r),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}