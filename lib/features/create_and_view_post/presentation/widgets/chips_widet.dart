import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class PostTypeToggle extends StatelessWidget {
  final PostType selectedType;
  final Function(PostType) onSelected;

  const PostTypeToggle({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                label: "Offers",
                postType: PostType.offer,
                isSelected: selectedType == PostType.offer,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildToggleButton(
                label: "Requests",
                postType: PostType.request,
                isSelected: selectedType == PostType.request,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required PostType postType,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(postType),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryBlue, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,

            color: isSelected ? Colors.white : AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
