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

class RequestsSection extends StatelessWidget {
  const RequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return SizedBox(
            height: 365.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is HistoryError) {
          return EmptyOrErrorCard(
            context: context,
            message: state.message.tr(),
          );
        }

        final requestedPosts = state is HistoryLoaded
            ? state.posts.where((p) => p.postType == PostType.request).toList()
            : <PostEntity>[];

        if (requestedPosts.isEmpty) {
          return EmptyOrErrorCard(
            context: context,
            message: 'history_screen.no_requests_currently'.tr(),
          );
        }

        return CarouselSlider.builder(
          itemCount: requestedPosts.length,
          options: CarouselOptions(
            height: 365.h,
            viewportFraction: 0.86,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            padEnds: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final post = requestedPosts[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              child: PostCard(
                post: post,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostDetailsScreen(isRequest: true, post: post),
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

void showDeleteAllConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text('history_screen.confirm_delete'.tr()),
      content: Text('history_screen.confirm_delete_all'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('history_screen.no'.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<HistoryBloc>().add(const ClearHistory());
          },
          child: Text(
            'history_screen.yes'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

void showDeleteConfirmation(BuildContext context, String postId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text('history_screen.confirm_delete'.tr()),
      content: Text('history_screen.confirm_delete_post'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('history_screen.no'.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<HistoryBloc>().add(DeletePost(postId: postId));
          },
          child: Text(
            'history_screen.yes'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
