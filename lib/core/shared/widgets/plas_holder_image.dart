import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlasHolder extends StatelessWidget {
  const PlasHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.image, color: Colors.grey[600], size: 64.w),
    );
  }
}
