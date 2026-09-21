import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';
import 'package:p/features/history/presentation/widgets/empty_orerror_card.dart';
import 'package:p/features/history/presentation/widgets/requests_section.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return SizedBox(
            height: 387.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HistoryError) {
          return EmptyOrErrorCard(context: context, message: state.message);
        }

        final offeredPosts = state is HistoryLoaded
            ? state.posts.where((p) => p.postType == PostType.offer).toList()
            : <PostEntity>[];

        if (offeredPosts.isEmpty) {
          return EmptyOrErrorCard(
            context: context,
            message: 'history_screen.no_offers_currently'.tr(),
          );
        }

        return CarouselSlider.builder(
          itemCount: offeredPosts.length,
          options: CarouselOptions(
            height: 387.h,
            viewportFraction: 0.86,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            padEnds: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final post = offeredPosts[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              child: PostCard(
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
                onDelete: () => showDeleteConfirmation(context, post.postId),
              ),
            );
          },
        );
      },
    );
  }
}
