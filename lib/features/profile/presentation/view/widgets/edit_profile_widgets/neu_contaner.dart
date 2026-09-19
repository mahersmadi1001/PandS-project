import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeuPContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BoxShape shape;

  const NeuPContainer({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(16.r)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.shade300,
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
