import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';

import 'package:p/view_temp/requests_page.dart';

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
                text: "Requests",
                icon: Icon(Icons.request_page, color: AppColors.lightBlue),
              ),
              Tab(
                text: "Offers",
                icon: Icon(
                  Icons.remember_me_rounded,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [RequsetsPage(), RequsetsPage()]),
      ),
    );
  }
}


// class CategoriesListWidget extends StatelessWidget {
//   const CategoriesListWidget();

//   @override
//   Widget build(BuildContext context) {
//     final categories = [
//       'الكل',
//       'برمجة وتطوير',
//       'تصميم',
//       'كتابة وترجمة',
//       'تسويق',
//     ];
//     return SizedBox(
//       height: 36.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final isSelected = index == 0;
//           return Container(
//             margin: EdgeInsets.only(left: 8.w),
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? AppColors.primaryBlue
//                   : Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(20.r),
//               border: isSelected
//                   ? null
//                   : Border.all(color: AppColors.borderLight),
//             ),
//             child: Text(
//               categories[index],
//               style: TextStyle(
//                 color: isSelected
//                     ? Colors.white
//                     : Theme.of(context).textTheme.bodyMedium?.color,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 14.sp,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
