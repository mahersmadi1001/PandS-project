import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showErrorSnackBar({required String message, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(message),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
    ),
  );
}

void showSuccessSnackBar({
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(message),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
    ),
  );
}
