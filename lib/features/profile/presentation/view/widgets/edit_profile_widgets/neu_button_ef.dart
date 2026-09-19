
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_contaner.dart';

class NeuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final bool isLoading;

  const NeuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: NeuPContainer(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPrimary ? AppColors.primaryBlue : Colors.grey,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isPrimary
                        ? AppColors.primaryBlue
                        : Colors.grey.shade700,
                  ),
                ),
        ),
      ),
    );
  }
}
