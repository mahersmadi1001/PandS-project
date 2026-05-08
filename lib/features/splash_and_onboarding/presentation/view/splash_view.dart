import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/theme/app_colors.dart';

import 'package:p/features/auth/presentation/view_model/user_session/user_session_bloc.dart'
    show
        UserSessionBloc,
        UserSessionCheckStatus,
        UserSessionState,
        UserFirstTimeState,
        UserAuthenticated,
        UserUnAuth;
import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:p/features/splash_and_onboarding/presentation/view/onbording_pages.dart';
import 'package:p/core/shared/nav_bar.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<UserSessionBloc>()..add(const UserSessionCheckStatus()),
      child: BlocListener<UserSessionBloc, UserSessionState>(
        listener: (context, state) {
          if (state is UserFirstTimeState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PageViewOnbording()),
            );
          } else if (state is UserAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else if (state is UserUnAuth) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          }
        },
        child: _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 90.r,
            child: Image.asset('assets/images/logo.PNG', fit: BoxFit.fill),
          ),
          Text(
            'P&S',
            style: TextStyle(
              shadows: const [Shadow(blurRadius: 3, offset: Offset(2, 2))],
              color: AppColors.primaryBlue,
              fontSize: 37.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 60.h),
          SizedBox(
            width: 220.w,
            child: const LinearProgressIndicator(
              color: AppColors.primaryBlue,
              backgroundColor: AppColors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
