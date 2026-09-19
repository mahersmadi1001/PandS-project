import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/neumorphic_styles.dart';


class CaeatorInfo extends StatelessWidget {
  final String creatorName;
  final String category;
  CaeatorInfo({super.key, required this.creatorName, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: NeumorphicStyles.getDecoration(context, borderRadius: 20.r),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: NeumorphicStyles.getDecoration(context, isCircle: true),
            child: Center(
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 28.w,
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creatorName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
