import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class TitleAppBar extends StatelessWidget {
  TitleAppBar({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        shadows: [
          Shadow(
            blurRadius: 10,
            offset: Offset(1.3, 2),
            color: AppColors.textPrimaryLight,
          ),
        ],
        color: AppColors.lightBlue,
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
