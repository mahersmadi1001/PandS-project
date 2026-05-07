import 'package:flutter/material.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

class PostCardFun {
  static Color getPostTypeColor({required PostEntity post}) {
    return post.postType == PostType.request ? Colors.orange : Colors.green;
  }

  static String getPostTypeText({required PostEntity post}) {
    return post.postType == PostType.request ? 'reguest' : 'offer';
  }

  static String formatTime({required String createdAt}) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        if (difference.inDays == 1) {
          return "Since a day";
        } else if (difference.inDays <= 7) {
          return 'Since ${difference.inDays} days';
        } else if (difference.inDays <= 30) {
          final weeks = (difference.inDays / 7).floor();
          return weeks == 1 ? 'Since a week' : 'Since $weeks weeks';
        } else {
          final months = (difference.inDays / 30).floor();
          return months == 1 ? 'Since a month' : 'Since $months months';
        }
      } else if (difference.inHours > 0) {
        if (difference.inHours == 1) {
          return 'Since an hour';
        } else {
          return 'Since ${difference.inHours} hours';
        }
      } else if (difference.inMinutes > 0) {
        if (difference.inMinutes == 1) {
          return 'Since a minute';
        } else {
          return 'Since ${difference.inMinutes} minutes';
        }
      } else {
        return 'Now';
      }
    } catch (e) {
      return createdAt;
    }
  }
}
