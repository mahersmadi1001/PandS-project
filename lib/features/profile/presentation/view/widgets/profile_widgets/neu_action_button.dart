import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class NeuActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const NeuActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeuContainer(
        padding: EdgeInsets.all(10.r),
        child: Icon(icon, color: AppColors.primaryBlue, size: 22.sp),
      ),
    );
  }
}
