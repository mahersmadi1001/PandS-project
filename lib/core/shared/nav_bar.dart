import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glaze_nav_bar/glaze_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/usecases/create_post_usecase.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';
import 'package:p/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:p/features/create_and_view_post/presentation/views/creat_post.dart';

import 'package:p/features/create_and_view_post/presentation/views/home_screen.dart';
import 'package:p/features/history/presentation/view/history_screen.dart';
import 'package:p/features/profile/presentation/view/profile_screen.dart';
import 'package:p/features/profile/presentation/view/profile_view_screen.dart';
import 'package:p/features/settings/presentation/view/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    CreateOrderScreen(),
    ProfileViewScreen(),
    SettingsScreen(),
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(
        createPostUsecase: di<CreatePostUsecase>(),
        getSavedSessionUsecase: di<GetSavedSessionUsecase>(),
        historyBloc: di<HistoryBloc>(),
      ),
      child: Scaffold(
        body: _screens[currentIndex],

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Builder(
          builder: (innerContext) {
            return GlazeNavBar(
              buttonBorderColor: AppColors.textSecondaryDark,
              glassBorderRadius: 12.r,
              buttonBackgroundColor: AppColors.primaryBlue,
              backgroundColor: Colors.transparent,
              color: AppColors.primaryBlue,
              onTap: (value) => setState(() => currentIndex = value),
              items: [
                GlazeNavBarItem(
                  label: "navigation.home".tr(context: innerContext),
                  labelStyle: TextStyle(color: AppColors.lightBlue),
                  child: Icon(Icons.home, color: AppColors.lightBlue),
                ),
                GlazeNavBarItem(
                  labelStyle: TextStyle(color: AppColors.lightBlue),
                  label: "navigation.history".tr(context: innerContext),
                  child: Icon(
                    Icons.history_edu_rounded,
                    color: AppColors.lightBlue,
                  ),
                ),
                GlazeNavBarItem(
                  label: "post.create_post".tr(context: innerContext),
                  child: Icon(Icons.create, color: AppColors.lightBlue),
                  labelStyle: TextStyle(color: AppColors.lightBlue),
                ),
                GlazeNavBarItem(
                  child: Icon(Icons.person, color: AppColors.lightBlue),
                  label: "navigation.profile".tr(context: innerContext),
                  labelStyle: TextStyle(color: AppColors.lightBlue),
                ),
                GlazeNavBarItem(
                  child: Icon(Icons.settings, color: AppColors.lightBlue),
                  label: "navigation.settings".tr(context: innerContext),
                  labelStyle: TextStyle(color: AppColors.lightBlue),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
