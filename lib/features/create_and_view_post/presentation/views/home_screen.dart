import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';

import 'package:p/features/create_and_view_post/presentation/widgets/requests_page.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/offers_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue,
          toolbarHeight: 35.h,
          title: TitleAppBar(title: "Posts"),
          bottom: TabBar(
            dividerColor: AppColors.textSecondaryLight,
            indicatorPadding: EdgeInsets.all(8.sp),
            unselectedLabelColor: AppColors.textSecondaryDark,
            labelStyle: TextStyle(color: AppColors.lightBlue),
            tabs: [
              Tab(
                text: "الطلبات",
                icon: Icon(Icons.request_page, color: AppColors.lightBlue),
              ),
              Tab(
                text: "العروض",
                icon: Icon(
                  Icons.remember_me_rounded,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Requests tab with its own BLoC instance
            BlocProvider(
              create: (context) => sl<GetPostsBloc>(),
              child: const RequsetsPage(),
            ),
            // Offers tab with its own BLoC instance
            BlocProvider(
              create: (context) => sl<GetPostsBloc>(),
              child: const OffersPage(),
            ),
          ],
        ),
      ),
    );
  }
}
