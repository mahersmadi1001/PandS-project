import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/theme/neumorphic_styles.dart';
import 'package:p/features/create_and_view_post/domain/usecases/create_post_usecase.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';
import 'package:p/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:p/features/create_and_view_post/presentation/views/creat_post.dart';
import 'package:p/features/create_and_view_post/presentation/views/home_screen.dart';
import 'package:p/features/history/presentation/view/history_screen.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(
        createPostUsecase: di<CreatePostUsecase>(),
        getSavedSessionUsecase: di<GetSavedSessionUsecase>(),
        historyBloc: di<HistoryBloc>(),
      ),
      child: Scaffold(
        extendBody: true,
        body: _screens[currentIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            height: 65.h,
            decoration: NeumorphicStyles.getDecoration(context, borderRadius: 32.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, "navigation.home".tr()),
                _buildNavItem(1, Icons.history_rounded, "navigation.history".tr()),
                _buildNavItem(2, Icons.add_circle_outline_rounded, "post.create_post".tr()),
                _buildNavItem(3, Icons.person_rounded, "navigation.profile".tr()),
                _buildNavItem(4, Icons.settings_rounded, "navigation.settings".tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16.w : 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 24.w,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: EdgeInsets.only(left: isSelected ? 8.w : 0, right: isSelected ? 8.w : 0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}