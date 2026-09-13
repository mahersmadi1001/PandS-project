import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';
import 'package:p/core/theme/neumorphic_styles.dart';

class RequsetsPage extends StatefulWidget {
  const RequsetsPage({super.key});

  @override
  State<RequsetsPage> createState() => _RequsetsPageState();
}

class _RequsetsPageState extends State<RequsetsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetPostsBloc>().add(FetchPosts(postType: PostType.request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: NeumorphicStyles.getDecoration(
                              context,
                              isCircle: true,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 48.w,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'error_messages.fetch_requests_error'.tr(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.message.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 32.h),
                          GestureDetector(
                            onTap: () {
                              context.read<GetPostsBloc>().add(
                                RefreshPosts(postType: PostType.request),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 14.h,
                              ),
                              decoration: NeumorphicStyles.getDecoration(
                                context,
                                borderRadius: 16.r,
                              ),
                              child: Text(
                                'error_messages.retry'.tr(),
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ),
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
                            Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: NeumorphicStyles.getDecoration(
                                context,
                                isCircle: true,
                              ),
                              child: Icon(
                                Icons.inbox_outlined,
                                size: 56.w,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'error_messages.no_requests'.tr(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'error_messages.try_later_create_request'.tr(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }

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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                decoration: NeumorphicStyles.getDecoration(
                                  context,
                                  borderRadius: 24.r,
                                ),
                                child: Text(
                                  category,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              ...categoryPosts.map(
                                (post) => Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: PostCard(
                                    post: post,
                                    onTap: () {},
                                    onOfferTap: () {
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
