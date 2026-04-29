import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryBlue,
                        width: 3.8,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryBlue,
                        width: 2.3,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    ),
                    hintStyle: TextStyle(fontSize: 14.sp),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondaryDark,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.lightBlue,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
