import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/list_address.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';

class ButtonShowListCategory extends StatefulWidget {
  const ButtonShowListCategory({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });
  final String selectedCategory;
  final Function(String) onCategorySelected;
  @override
  State<ButtonShowListCategory> createState() => _ButtonShowListCategoryState();
}

class _ButtonShowListCategoryState extends State<ButtonShowListCategory> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primaryBlue, width: 2),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(16.r)),
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
              height: 600.h,
              child: Center(
                child: ListAddress(
                  items: ConstensApp.serviceCategories,
                  selectedItem: widget.selectedCategory,
                  onSelected: (category) {
                    widget.onCategorySelected(category);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
      child: Expanded(
        child: Row(
          spacing: 8.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.selectedCategory ?? "Categories",
                style: TextStyle(color: AppColors.primaryBlue),
              ),
            ),
            Icon(Icons.arrow_downward, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }
}
