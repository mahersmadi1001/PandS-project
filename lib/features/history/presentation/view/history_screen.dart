import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryBloc>().add(const GetHistoryPosts());
    });
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف جميع السجل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HistoryBloc>().add(const ClearHistory());
            },
            child: const Text('نعم', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المنشور؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HistoryBloc>().add(DeletePost(postId: postId));
            },
            child: const Text('نعم', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "History"),
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                onPressed: () {
                  _showDeleteAllConfirmation(context);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requests section with carousel
            Padding(
              padding: EdgeInsets.all(8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Requests",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () {
                      _showDeleteAllConfirmation(context);
                    },
                  ),
                ],
              ),
            ),

            // Requests carousel
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is HistoryError) {
                  return SizedBox(
                    height: 200.sp,
                    child: Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    ),
                  );
                }

                final requestedPosts = state is HistoryLoaded
                    ? state.posts
                          .where((p) => p.postType == PostType.request)
                          .toList()
                    : <PostEntity>[];

                if (requestedPosts.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'لا توجد طلبات حالياً',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      height: 290.h,
                      enableInfiniteScroll: false,
                    ),
                    items: requestedPosts.map((post) {
                      return PostCard(
                        post: post,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PostDetailsScreen(
                                  isRequest: true,
                                  post: post,
                                );
                              },
                            ),
                          );
                        },
                        onOfferTap: null,
                        onDelete: () =>
                            _showDeleteConfirmation(context, post.postId),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Offers section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Offers",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () {
                      _showDeleteAllConfirmation(context);
                    },
                  ),
                ],
              ),
            ),

            // Offers carousel
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is HistoryError) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    ),
                  );
                }

                final offeredPosts = state is HistoryLoaded
                    ? state.posts
                          .where((p) => p.postType == PostType.offer)
                          .toList()
                    : <PostEntity>[];

                if (offeredPosts.isEmpty) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Text(
                        'لا توجد عروض حالياً',
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      height: 290.h,
                      enableInfiniteScroll: false,
                    ),
                    items: offeredPosts.map((post) {
                      return PostCard(
                        post: post,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailsScreen(
                                post: post,
                                isRequest: post.postType == PostType.request,
                              ),
                            ),
                          );
                        },
                        onOfferTap: null,
                        onDelete: () =>
                            _showDeleteConfirmation(context, post.postId),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
