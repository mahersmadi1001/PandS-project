import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/cttf.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/view_temp/chips_widet.dart';
import 'package:p/view_temp/list_address.dart';
import 'package:p/view_temp/upload_box.dart';

String selectedPostType = "Offers";

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "Create Post"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),

        child: Column(
          children: [
            const CustomTextField(
              label: "Title",
              hint: "Example:  professional logo design is required",
            ),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.primaryBlue, width: 2),
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(16.r),
                      ),
                    ),

                    height: 55.h,
                    minWidth: 240.w,
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        backgroundColor: AppColors.cardLight,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 500.h,
                            child: Center(
                              child: ListAddress(
                                items: ConstensApp.serviceCategories,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(color: AppColors.primaryBlue),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.primaryBlue, width: 2),
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(16.r),
                      ),
                    ),

                    height: 55.h,
                    minWidth: 240.w,
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: AppColors.cardLight,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 300.h,
                            child: Center(
                              child: ListAddress(
                                items: ConstensApp.syrianGovernorates,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Addrees",
                          style: TextStyle(color: AppColors.primaryBlue),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(label: "Budget", hint: "50\$"),
                ),

                SizedBox(width: 15.w),

                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type Post",
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: PostTypeToggle(
                              selectedType: selectedPostType,
                              onSelected: (value) {
                                setState(() {
                                  selectedPostType = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const CustomTextField(
              label: "Detailed description",
              hint: "Explain what you need in detail...",
              maxLines: 4,
            ),

            const UploadBox(),

            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.sp),
          ],
        ),
      ),
    );
  }
}
