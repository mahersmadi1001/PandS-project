import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/services/history_service.dart';
import 'package:p/core/shared/widgets/post_card.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "السجل"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'طلباتي'),
            Tab(text: 'عروضي'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Requests tab
          FutureBuilder<List<PostEntity>>(
            future: HistoryService.getRequestedPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final requestedPosts = snapshot.data ?? [];

              if (requestedPosts.isEmpty) {
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
                        'لا توجد طلبات محفوظة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'ابدأ بإنشاء طلب جديد',
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
              for (final post in requestedPosts) {
                final category = post.category;
                if (!postsByCategory.containsKey(category)) {
                  postsByCategory[category] = [];
                }
                postsByCategory[category]!.add(post);
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: postsByCategory.keys.length,
                itemBuilder: (context, index) {
                  final category = postsByCategory.keys.elementAt(index);
                  final categoryPosts = postsByCategory[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      // Category header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '$category (${categoryPosts.length})',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Posts in this category
                      ...categoryPosts.map(
                        (post) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: PostCard(
                            post: post,
                            onTap: () {
                              // Navigate to post details
                            },
                            onOfferTap: null, // No offer button for history
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Offers tab
          FutureBuilder<List<PostEntity>>(
            future: HistoryService.getOfferedPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final offeredPosts = snapshot.data ?? [];

              if (offeredPosts.isEmpty) {
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
                        'لا توجد عروض محفوظة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'ابدأ بإنشاء عرض جديد',
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
              for (final post in offeredPosts) {
                final category = post.category;
                if (!postsByCategory.containsKey(category)) {
                  postsByCategory[category] = [];
                }
                postsByCategory[category]!.add(post);
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: postsByCategory.keys.length,
                itemBuilder: (context, index) {
                  final category = postsByCategory.keys.elementAt(index);
                  final categoryPosts = postsByCategory[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      // Category header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '$category (${categoryPosts.length})',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Posts in this category
                      ...categoryPosts.map(
                        (post) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: PostCard(
                            post: post,
                            onTap: () {
                              // Navigate to post details
                            },
                            onOfferTap: null, // No offer button for history
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
