// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:p/core/theme/app_colors.dart';

class Onbording extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? button;
  final String supTitle;
  final String buttonText;
  Widget back = SizedBox();
  final PageController controller;
  Onbording({
    required this.controller,
    required this.icon,
    required this.title,
    required this.button,
    required this.buttonText,
    required this.supTitle,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(),
          SizedBox(height: 150.h),
          Container(
            height: 250.h,
            width: 250.w,
            decoration: BoxDecoration(
              boxShadow: [],
              border: Border.all(color: AppColors.borderLight, width: 2),
              shape: BoxShape.circle,
              color: Color(0xffeff3fc),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 78.sp),
          ),
          SizedBox(height: 30.h),
          Text(
            title,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          Text(
            supTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 18.sp,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 65.h),
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 32.w,
                  height: 12.h,
                  color: AppColors.primaryBlue,
                  rotationAngle: 180,
                  verticalOffset: -10,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                dotDecoration: DotDecoration(
                  width: 24.w,
                  height: 12.h,
                  color: AppColors.textSecondaryDark,

                  borderRadius: BorderRadius.circular(16.r),
                  verticalOffset: 0,
                ),
                spacing: 6.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              back,
              SizedBox(width: 20.w),
              CustomButton(buttonText: buttonText, ontap: button),
            ],
          ),
        ],
      ),
    );
  }
}
