import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';

Future<dynamic> filterButtomSheet({
  required BuildContext context,
  required Function applyFilters,
  required String? selectedProvince,
  required List selectedCategories,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        String? tempProvince = selectedProvince;
        List<String> tempCategories = List.from(selectedCategories);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtering options',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempProvince = null;
                          tempCategories.clear();
                        });
                      },
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Province selection (single selection)
                      Text(
                        'Province',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: ConstensApp.syrianGovernorates.map((
                          province,
                        ) {
                          final isSelected = tempProvince == province;
                          return ChoiceChip(
                            label: Text(
                              province,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.cardLight
                                    : AppColors.primaryBlue,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primaryBlue,
                            onSelected: (selected) {
                              setState(() {
                                tempProvince = selected ? province : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 24.h),

                      // Service categories (multiple selection)
                      Text(
                        'Service type',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: ConstensApp.serviceCategories.map((category) {
                          final isSelected = tempCategories.contains(category);
                          return ChoiceChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.cardLight
                                    : AppColors.primaryBlue,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primaryBlue,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  tempCategories = [category];
                                } else {
                                  tempCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Apply button
              Container(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedProvince = tempProvince!;
                        selectedCategories = tempCategories;
                      });
                      Navigator.pop(context);
                      applyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Apply filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
