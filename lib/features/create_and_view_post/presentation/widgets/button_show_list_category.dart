
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/list_address.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';

class ButtonShowListCategory extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const ButtonShowListCategory({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      onPressed: () {
        showModalBottomSheet(
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          context: context,
          builder: (context) {
            return SizedBox(
              height: 600.h,
              child: Center(
                child: ListAddress(
                  items: ConstensApp.serviceCategories,
                  selectedItem: selectedCategory,
                  onSelected: (category) {
                    onCategorySelected(category);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              selectedCategory,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 13.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue, size: 20.sp),
        ],
      ),
    );
  }
}