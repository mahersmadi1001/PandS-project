import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:p/core/shared/widgets/post_card.dart';
import 'package:p/core/shared/widgets/search_filter_widget.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class RequsetsPage extends StatefulWidget {
  const RequsetsPage({super.key});

  @override
  State<RequsetsPage> createState() => _RequsetsPageState();
}

class _RequsetsPageState extends State<RequsetsPage> {
  String _searchQuery = '';
  String? _selectedProvince;
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    // Fetch posts when the screen loads
    context.read<GetPostsBloc>().add(FetchPosts(postType: PostType.request));
  }

  void _applyFilters() {
    context.read<GetPostsBloc>().add(
      FilterPosts(
        postType: PostType.request,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchFilterWidget(
              selectedProvince: _selectedProvince,
              selectedCategories: _selectedCategories,
              onSearchChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
              onProvinceSelected: (province) {
                setState(() {
                  _selectedProvince = province;
                });
                _applyFilters();
              },
              onCategoriesSelected: (categories) {
                setState(() {
                  _selectedCategories = categories;
                });
                _applyFilters();
              },
              onFilterTap: () {},
            ),

            // Posts list
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
                            'حدث خطأ في جلب الطلبات',
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
                              context.read<GetPostsBloc>().add(
                                RefreshPosts(postType: PostType.request),
                              );
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
                              Icons.inbox_outlined,
                              size: 64.w,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'لا توجد طلبات حالياً',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'حاول لاحقاً أو قم بإنشاء طلب جديد',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Group posts by category
                    final Map<String, List<PostEntity>> postsByCategory = {};
                    for (final post in state.posts) {
                      final category = post.category;
                      if (!postsByCategory.containsKey(category)) {
                        postsByCategory[category] = [];
                      }
                      postsByCategory[category]!.add(post);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<GetPostsBloc>().add(
                          RefreshPosts(postType: PostType.request),
                        );
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: postsByCategory.keys.length,
                        itemBuilder: (context, index) {
                          final category = postsByCategory.keys.elementAt(
                            index,
                          );
                          final categoryPosts = postsByCategory[category]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              // Category header
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Posts in this category
                              ...categoryPosts.map(
                                (post) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: PostCard(
                                    post: post,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailsScreen(
                                                isRequest: true,
                                                post: post,
                                              ),
                                        ),
                                      );
                                    },
                                    onOfferTap: () {
                                      // Handle offer submission
                                    },
                                  ),
                                ),
                              ),
                            ],
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
