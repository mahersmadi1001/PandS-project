import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:p/core/theme/app_colors.dart';

class ListAddress extends StatefulWidget {
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
  State<ListAddress> createState() => _ListAddressState();
}

class _ListAddressState extends State<ListAddress> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 17.w,
      runSpacing: 16.h,
      children: widget.items.map((district) {
        return ChoiceChip(
          label: Text(district),

          selected: widget.selectedItem == district,

          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                widget.onSelected(district);
              }
            });
          },

          selectedColor: AppColors.primaryBlue,
          labelStyle: TextStyle(
            fontSize: 16.sp,

            fontWeight: widget.selectedItem == district
                ? FontWeight.bold
                : FontWeight.normal,
            color: widget.selectedItem == district
                ? AppColors.cardLight
                : AppColors.primaryBlue,
          ),
        );
      }).toList(),
    );
  }
}
