import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';

class ListAddress extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onSelected;

  const ListAddress({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 12.w,
      runSpacing: 12.h,
      children: items.map((district) {
        final isSelected = selectedItem == district;
        return ChoiceChip(
          label: Text(district),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              onSelected(district);
            }
          },
          selectedColor: AppColors.primaryBlue,
          backgroundColor: isDark ? Colors.black26 : Colors.white,
          side: BorderSide(
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.grey.withOpacity(0.3),
          ),
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : AppColors.primaryBlue),
          ),
        );
      }).toList(),
    );
  }
}
