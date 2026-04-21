import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/presentation/views/onbording_pages.dart';

class SplashView extends StatefulWidget {
  SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageViewOnbording()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8fafc),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 90.r,
            child: Container(
              child: Image.asset("assets/images/logo.PNG", fit: BoxFit.fill),
            ),
          ),
          Text(
            "P&S",
            style: TextStyle(
              shadows: [Shadow(blurRadius: 3, offset: Offset(2, 2))],
              color: AppColors.primaryBlue,
              fontSize: 37.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 60.h),
          SizedBox(
            width: 220.w,
            child: LinearProgressIndicator(
              color: AppColors.primaryBlue,
              backgroundColor: AppColors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
