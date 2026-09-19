import 'package:flutter/material.dart';

class StaggeredFadeSlide extends StatelessWidget {
  final Widget child;
  final int index;

  const StaggeredFadeSlide({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
   
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}