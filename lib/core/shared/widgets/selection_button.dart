import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class SelectionButton extends StatelessWidget {
  final String? selectedItem;
  final String placeholder;
  final VoidCallback onPressed;
  final List<String> items;
  final String title;

  const SelectionButton({
    Key? key,
    required this.selectedItem,
    required this.placeholder,
    required this.onPressed,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primaryBlue, width: 2),
          borderRadius: BorderRadiusGeometry.all(Radius.circular(16.r)),
        ),
        height: 55.h,
        minWidth: 240.w,
        onPressed: onPressed,
        child: Row(
          spacing: 8.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                selectedItem ?? placeholder,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.arrow_downward,
              color: AppColors.primaryBlue,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionBottomSheet extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onSelected;
  final String title;

  const SelectionBottomSheet({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItem == item;
                
                return ListTile(
                  title: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryBlue : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: AppColors.primaryBlue)
                      : null,
                  onTap: () {
                    onSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
