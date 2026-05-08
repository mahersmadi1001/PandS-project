import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';

import 'package:p/core/theme/app_colors.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedProvince;
  List<String> _selectedCategories = [];
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Load initial posts
    context.read<GetPostsBloc>().add(FetchPosts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<GetPostsBloc>().add(
      FilterPosts(
        province: _selectedProvince,
        category: _selectedCategories.isNotEmpty
            ? _selectedCategories.first
            : null,
      ),
    );

    // Apply search if there's a search query
    if (_searchQuery.isNotEmpty) {
      context.read<GetPostsBloc>().add(SearchPosts(searchQuery: _searchQuery));
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _applyFilters();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String? tempProvince = _selectedProvince;
          List<String> tempCategories = List.from(_selectedCategories);

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
                          _selectedProvince = tempProvince;
                          _selectedCategories = tempCategories;
                        });
                        Navigator.pop(context);
                        _applyFilters();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "البحث"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
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
                      hintText: 'ابحث عن خدمات...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondaryDark,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Filter Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showFilterBottomSheet(context),
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                            color: AppColors.lightBlue,
                          ),
                          label: Text(
                            'الفلترة',
                            style: TextStyle(
                              color: AppColors.lightBlue,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                      if (_selectedProvince != null ||
                          _selectedCategories.isNotEmpty)
                        SizedBox(width: 8.w),
                      if (_selectedProvince != null ||
                          _selectedCategories.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedProvince = null;
                              _selectedCategories.clear();
                            });
                            _applyFilters();
                          },
                          icon: const Icon(
                            Icons.clear_all,
                            color: AppColors.primaryBlue,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue.withOpacity(
                              0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Results Section
            Expanded(
              child: BlocBuilder<GetPostsBloc, GetPostsState>(
                builder: (context, state) {
                  if (state is GetPostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetPostsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.w,
                            color: Colors.red[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'حدث خطأ في البحث',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<GetPostsBloc>().add(FetchPosts());
                            },
                            child: Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is GetPostsLoaded) {
                    if (state.posts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64.w,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'لا توجد نتائج للبحث',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'جرب تغيير كلمات البحث أو الفلاتر',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<GetPostsBloc>().add(FetchPosts());
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: PostCard(
                              post: post,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailsScreen(
                                      isRequest:
                                          post.postType == PostType.request,
                                      post: post,
                                    ),
                                  ),
                                );
                              },
                              onOfferTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailsScreen(
                                      isRequest:
                                          post.postType == PostType.request,
                                      post: post,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
