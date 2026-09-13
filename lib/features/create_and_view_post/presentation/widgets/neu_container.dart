

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeuContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NeuContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    
    final lightShadow = isDark ? Colors.white.withOpacity(0.03) : Colors.white;
    final darkShadow = isDark ? Colors.black.withOpacity(0.4) : const Color(0xFFA3B1C6).withOpacity(0.5);

    return Container(
      padding: padding ?? EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: lightShadow,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: darkShadow,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}