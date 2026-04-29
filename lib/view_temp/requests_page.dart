import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/home_header.dart';

import 'package:p/view_temp/job_card_widget.dart';

class RequsetsPage extends StatelessWidget {
  const RequsetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeaderWidget(),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const JobCardWidget(
                    title: 'مطلوب تصميم واجهة مستخدم لتطبيق توصيل',
                    location: 'عن بعد',
                    priceRange: '\$500 - \$1000',
                    authorName: 'أحمد صالح',
                    timeAgo: 'منذ ساعتين',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
