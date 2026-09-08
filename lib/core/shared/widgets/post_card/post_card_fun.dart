import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class PostCardFun {
  static Color getPostTypeColor({required PostEntity post}) {
    return post.postType == PostType.request ? Colors.orange : Colors.green;
  }

  static String getPostTypeText({required PostEntity post}) {
    return post.postType == PostType.request ? 'reguest' : 'offer';
  }

  static String formatTime({
    required String createdAt,
    required BuildContext context,
  }) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        if (difference.inDays == 1) {
          return 'time_format.since_day'.tr();
        } else if (difference.inDays <= 7) {
          return 'time_format.since_days'.tr(args: ['${difference.inDays}']);
        } else if (difference.inDays <= 30) {
          final weeks = (difference.inDays / 7).floor();
          return weeks == 1
              ? 'time_format.since_week'.tr()
              : 'time_format.since_weeks'.tr(args: ['$weeks']);
        } else {
          final months = (difference.inDays / 30).floor();
          return months == 1
              ? 'time_format.since_month'.tr()
              : 'time_format.since_months'.tr(args: ['$months']);
        }
      } else if (difference.inHours > 0) {
        if (difference.inHours == 1) {
          return 'time_format.since_hour'.tr();
        } else {
          return 'time_format.since_hours'.tr(args: ['${difference.inHours}']);
        }
      } else if (difference.inMinutes > 0) {
        if (difference.inMinutes == 1) {
          return 'time_format.since_minute'.tr();
        } else {
          return 'time_format.since_minutes'.tr(
            args: ['${difference.inMinutes}'],
          );
        }
      } else {
        return 'time_format.now'.tr();
      }
    } catch (e) {
      return createdAt;
    }
  }
}
