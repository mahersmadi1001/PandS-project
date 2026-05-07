import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/auth/data/datasources/local.dart';

class HistoryService {
  static const String _historyBox = 'history_box';

  /// Save a post to user history
  static Future<void> savePostToHistory(PostEntity post) async {
    try {
      final authLocalDataSource = AuthLocalDataSourceImpl();
      final userId = authLocalDataSource.getSession();
      if (userId == null) return;

      final box = await Hive.openBox(_historyBox);
      final historyList = _getHistoryList(box, userId);

      // Add post to the beginning of the list
      historyList.insert(0, post.toMap());

      // Keep only last 50 posts to avoid storage bloat
      if (historyList.length > 50) {
        historyList.removeRange(50, historyList.length);
      }

      await box.put('${userId}_history', jsonEncode(historyList));
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  /// Get all posts from user history
  static Future<List<PostEntity>> getHistoryPosts() async {
    try {
      final authLocalDataSource = AuthLocalDataSourceImpl();
      final userId = authLocalDataSource.getSession();
      if (userId == null) return [];

      final box = await Hive.openBox(_historyBox);
      final historyList = _getHistoryList(box, userId);

      return historyList.map((postMap) => PostEntity.fromMap(postMap)).toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }

  /// Get only requested posts from history
  static Future<List<PostEntity>> getRequestedPosts() async {
    final allPosts = await getHistoryPosts();
    return allPosts.where((post) => post.postType == PostType.request).toList();
  }

  /// Get only offered posts from history
  static Future<List<PostEntity>> getOfferedPosts() async {
    final allPosts = await getHistoryPosts();
    return allPosts.where((post) => post.postType == PostType.offer).toList();
  }

  /// Clear user history
  static Future<void> clearHistory() async {
    try {
      final authLocalDataSource = AuthLocalDataSourceImpl();
      final userId = authLocalDataSource.getSession();
      if (userId == null) return;

      final box = await Hive.openBox(_historyBox);
      await box.delete('${userId}_history');
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// Remove a specific post from history
  static Future<void> removeFromHistory(String postId) async {
    try {
      final authLocalDataSource = AuthLocalDataSourceImpl();
      final userId = authLocalDataSource.getSession();
      if (userId == null) return;

      final box = await Hive.openBox(_historyBox);
      final historyList = _getHistoryList(box, userId);

      historyList.removeWhere((postMap) => postMap['postId'] == postId);

      await box.put('${userId}_history', jsonEncode(historyList));
    } catch (e) {
      print('Error removing from history: $e');
    }
  }

  /// Helper method to get and parse history list
  static List<Map<String, dynamic>> _getHistoryList(Box box, String userId) {
    final historyData = box.get('${userId}_history');
    if (historyData == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(historyData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error parsing history data: $e');
      return [];
    }
  }
}
