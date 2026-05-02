import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';

class ListAddress extends StatefulWidget {
  ListAddress({super.key, required this.items});
  static String? selectedAddress;
  List items;
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

          selected: ListAddress.selectedAddress == district,

          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                ListAddress.selectedAddress = district;
              }
            });
            print(ListAddress.selectedAddress);
          },

          selectedColor: AppColors.primaryBlue,
          labelStyle: TextStyle(
            fontSize: 16.sp,

            fontWeight: ListAddress.selectedAddress == district
                ? FontWeight.bold
                : FontWeight.normal,
            color: ListAddress.selectedAddress == district
                ? AppColors.cardLight
                : AppColors.primaryBlue,
          ),
        );
      }).toList(),
    );
  }
}
