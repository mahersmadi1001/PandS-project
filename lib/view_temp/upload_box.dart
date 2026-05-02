import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class UploadBox extends StatelessWidget {
  const UploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade100,
          style: BorderStyle.solid,
        ),
        color: Colors.blue.withAlpha(30),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.primaryBlue,
            size: 30.w,
          ),
          SizedBox(height: 10.h),
          Text("Upload image"),
        ],
      ),
    );
  }
}
