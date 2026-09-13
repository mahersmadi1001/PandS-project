import 'package:flutter/material.dart';
import 'package:p/core/theme/app_colors.dart';

class NeumorphicStyles {
  static BoxDecoration getDecoration(
    BuildContext context, {
    double borderRadius = 12,
    bool isCircle = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.shadowDarkBottom
              : AppColors.shadowLightBottom,
          offset: const Offset(4, 4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: isDark ? AppColors.shadowDarkTop : AppColors.shadowLightTop,
          offset: const Offset(-4, -4),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
