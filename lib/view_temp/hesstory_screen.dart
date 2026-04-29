import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/view_temp/job_card_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "Hisstory"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Requests",
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
              ),
              items: [
                JobCardWidget(
                  title: "mmm",
                  location: "aksjd",
                  priceRange: "alskjd",
                  authorName: "asldkj",
                  timeAgo: "amsdnas",
                ),
                JobCardWidget(
                  title: "mmm",
                  location: "aksjd",
                  priceRange: "alskjd",
                  authorName: "asldkj",
                  timeAgo: "amsdnas",
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Offers",
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
              ),
              items: [
                JobCardWidget(
                  title: "mmm",
                  location: "aksjd",
                  priceRange: "alskjd",
                  authorName: "asldkj",
                  timeAgo: "amsdnas",
                ),
                JobCardWidget(
                  title: "mmm",
                  location: "aksjd",
                  priceRange: "alskjd",
                  authorName: "asldkj",
                  timeAgo: "amsdnas",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
