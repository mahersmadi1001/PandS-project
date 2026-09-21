import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/neumorphic_styles.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/requests_page.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/offers_page.dart';
import 'package:p/features/create_and_view_post/presentation/views/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          toolbarHeight: 60.h,
          title: TitleAppBar(title: "post.view_posts".tr()),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => di<GetPostsBloc>(),
                        child: const SearchScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: NeumorphicStyles.getDecoration(
                    context,
                    isCircle: true,
                  ),
                  child: Icon(
                    Icons.search,
                    color: colorScheme.primary,
                    size: 22.w,
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                height: 50.h,
                decoration: NeumorphicStyles.getDecoration(
                  context,
                  borderRadius: 24.r,
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(4.w),
                  splashBorderRadius: BorderRadius.circular(20.r),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),

                    color: colorScheme.primary.withOpacity(0.15),
                  ),
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.request_page_outlined, size: 20.w),
                          SizedBox(width: 8.w),
                          Text("home_screen.requests".tr()),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_offer_outlined, size: 20.w),
                          SizedBox(width: 8.w),
                          Text("home_screen.offers".tr()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            BlocProvider(
              create: (context) => di<GetPostsBloc>(),
              child: const RequsetsPage(),
            ),
            BlocProvider(
              create: (context) => di<GetPostsBloc>(),
              child: const OffersPage(),
            ),
          ],
        ),
      ),
    );
  }
}
