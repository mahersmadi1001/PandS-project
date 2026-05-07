import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/list_address.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';

class ButtonShowListAddrees extends StatefulWidget {
  const ButtonShowListAddrees({
    super.key,
    required this.selectedProvince,
    required this.onProvinceSelected,
  });
  final String selectedProvince;
  final Function(String) onProvinceSelected;
  @override
  State<ButtonShowListAddrees> createState() => _ButtonShowListAddreesState();
}

class _ButtonShowListAddreesState extends State<ButtonShowListAddrees> {
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
          backgroundColor: AppColors.cardLight,
          context: context,
          builder: (context) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: ListAddress(
                  items: ConstensApp.syrianGovernorates,
                  selectedItem: widget.selectedProvince,
                  onSelected: (province) {
                    widget.onProvinceSelected(province);
                    Navigator.pop(context);
                  },
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
            widget.selectedProvince ?? "Addrees",
            style: TextStyle(color: AppColors.primaryBlue),
          ),
          Icon(Icons.arrow_downward, color: AppColors.primaryBlue),
        ],
      ),
    );
  }
}
