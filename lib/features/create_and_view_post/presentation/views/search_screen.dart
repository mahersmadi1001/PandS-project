import 'package:easy_localization/easy_localization.dart';
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
  String? selectedProvince;
  List<String> selectedCategories = [];
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
        province: selectedProvince,
        category: selectedCategories.isNotEmpty
            ? selectedCategories.first
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "general.search".tr()),
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
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondaryDark,
                      ),
                      hintText: "general.search".tr(),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.cardDark,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                  SizedBox(height: 12.h),
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
                            'An error occurred while searching',
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
                            child: Text('Retry'),
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
                              'No results found for your search',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try changing your search terms or filters',
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
