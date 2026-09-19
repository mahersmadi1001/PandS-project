import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/create_post_widgets/button_show_list_address.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_show_list_category.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class ListsRow extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedProvince;
  final Function(String) onCategorySelected;
  final Function(String) onProvinceSelected;

  const ListsRow({
    super.key,
    this.selectedCategory,
    this.selectedProvince,
    required this.onCategorySelected,
    required this.onProvinceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.all(8.r),
            child: ButtonShowListCategory(
              selectedCategory:
                  selectedCategory ?? "create_post.categories".tr(),
              onCategorySelected: onCategorySelected,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.all(8.r),
            child: ButtonShowListAddrees(
              selectedProvince: selectedProvince ?? "create_post.address".tr(),
              onProvinceSelected: onProvinceSelected,
            ),
          ),
        ),
      ],
    );
  }
}
