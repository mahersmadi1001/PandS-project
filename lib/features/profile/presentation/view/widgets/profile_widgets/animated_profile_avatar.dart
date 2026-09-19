import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class AnimatedProfileAvatar extends StatelessWidget {
  final String? imageUrl;

  const AnimatedProfileAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: NeuContainer(
        padding: EdgeInsets.all(6.r),
        child: Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: (imageUrl != null && imageUrl!.isNotEmpty)
              ? Image.network(imageUrl!, fit: BoxFit.cover)
              : Image.asset('assets/images/logo.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
