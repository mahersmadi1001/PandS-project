import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_show_list_address.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_show_list_category.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class ListsRow extends StatefulWidget {
  String? selectedCategory;
  String? selectedProvince;
  ListsRow({super.key, this.selectedCategory, this.selectedProvince});

  @override
  State<ListsRow> createState() => _ListsRowState();
}

class _ListsRowState extends State<ListsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.all(8.r),
            child: ButtonShowListCategory(
              selectedCategory:
                  widget.selectedCategory ?? "create_post.categories".tr(),
              onCategorySelected: (category) {
                setState(() {
                  widget.selectedCategory = category;
                });
              },
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.all(8.r),
            child: ButtonShowListAddrees(
              selectedProvince:
                  widget.selectedProvince ?? "create_post.address".tr(),
              onProvinceSelected: (province) {
                setState(() {
                  widget.selectedProvince = province;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
