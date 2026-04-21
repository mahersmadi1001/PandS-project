import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class BackButtonPage extends StatelessWidget {
  BackButtonPage({super.key, required this.ontap});
  GestureTapCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        child: Icon(Icons.arrow_back, color: AppColors.textPrimaryDark),
        radius: 23.r,
        backgroundColor: AppColors.textSecondaryDark,
      ),
    );
  }
}
