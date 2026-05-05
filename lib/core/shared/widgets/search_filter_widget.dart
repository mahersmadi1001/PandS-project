import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/core/string/list_addrees_string.dart';

class SearchFilterWidget extends StatefulWidget {
  final String? selectedProvince;
  final List<String> selectedCategories;
  final Function(String) onSearchChanged;
  final Function(String?) onProvinceSelected;
  final Function(List<String>) onCategoriesSelected;
  final VoidCallback onFilterTap;

  const SearchFilterWidget({
    Key? key,

    this.selectedProvince,
    this.selectedCategories = const [],
    required this.onSearchChanged,
    required this.onProvinceSelected,
    required this.onCategoriesSelected,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryBlue,
                        width: 3.8,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryBlue,
                        width: 2.3,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    ),
                    hintStyle: TextStyle(fontSize: 14.sp),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondaryDark,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.lightBlue,
                  ),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String? tempProvince = widget.selectedProvince;
          List<String> tempCategories = List.from(widget.selectedCategories);

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'خيارات الفلترة',
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
                          'مسح الكل',
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
                          'المحافظة',
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
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: FilterChip(
                                label: Text(
                                  province,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: isSelected ? 15.sp : 14.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                backgroundColor: isSelected
                                    ? AppColors.primaryBlue
                                    : Colors.grey[200],
                                selectedColor: AppColors.primaryBlue,
                                checkmarkColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                elevation: isSelected ? 4 : 1,
                                pressElevation: isSelected ? 6 : 2,
                                shadowColor: isSelected
                                    ? AppColors.primaryBlue.withAlpha(50)
                                    : Colors.black12,
                                onSelected: (selected) {
                                  setState(() {
                                    tempProvince = selected ? province : null;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 24.h),

                        // Service categories (multiple selection)
                        Text(
                          'نوع الخدمة',
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
                          children: ConstensApp.serviceCategories.map((
                            category,
                          ) {
                            final isSelected = tempCategories.contains(
                              category,
                            );
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: FilterChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: isSelected ? 15.sp : 14.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                backgroundColor: isSelected
                                    ? AppColors.primaryBlue
                                    : Colors.grey[200],
                                selectedColor: AppColors.primaryBlue,
                                checkmarkColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                elevation: isSelected ? 4 : 1,
                                pressElevation: isSelected ? 6 : 2,
                                shadowColor: isSelected
                                    ? AppColors.primaryBlue.withAlpha(50)
                                    : Colors.black12,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      tempCategories.add(category);
                                    } else {
                                      tempCategories.remove(category);
                                    }
                                  });
                                },
                              ),
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
                        widget.onProvinceSelected(tempProvince);
                        widget.onCategoriesSelected(tempCategories);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'تطبيق الفلتر',
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
}
