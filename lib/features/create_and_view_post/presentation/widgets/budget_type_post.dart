import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/custom_text_field.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/chips_widet.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';

class BudgetandTypePost extends StatefulWidget {
  PostType selectedPostType;
  TextEditingController? budgetController;
  BudgetandTypePost({
    super.key,
    required this.selectedPostType,
    required this.budgetController,
  });

  @override
  State<BudgetandTypePost> createState() => _BudgetandTypePostState();
}

class _BudgetandTypePostState extends State<BudgetandTypePost> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: NeuContainer(
            child: CustomTextField(
              label: "create_post.budget".tr(),
              hint: "create_post.budget_hint".tr(),
              controller: widget.budgetController,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          flex: 3,
          child: NeuContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "create_post.type_post".tr(),
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                PostTypeToggle(
                  selectedType: widget.selectedPostType,
                  onSelected: (value) {
                    setState(() {
                      widget.selectedPostType = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
