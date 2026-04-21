import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  VoidCallback? ontap;
  String buttonText;
  CustomButton({Key? key, this.ontap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50.h,
      minWidth: 300.w,
      color: AppColors.primaryBlue,
      onPressed: ontap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(22.r)),
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: AppColors.textPrimaryDark),
      ),
    );
  }
}
