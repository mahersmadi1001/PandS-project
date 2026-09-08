import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/auth/data/datasources/local.dart';

class HistoryService {
  static const String _historyBox = 'history_box';


  static Future<void> savePostToHistory(PostEntity post) async {
    try {
      final authLocalDataSource = AuthLocalDataSourceImpl();
      final userId = authLocalDataSource.getSession();
      if (userId == null) return;

      final box = await Hive.openBox(_historyBox);
      final historyList = _getHistoryList(box, userId);

      historyList.insert(0, post.toMap());

   
      if (historyList.length > 50) {
        historyList.removeRange(50, historyList.length);
      }

      await box.put('${userId}_history', jsonEncode(historyList));
    } catch (e) {
      print('Error saving to history: $e');
    }
  }


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

  
  static Future<List<PostEntity>> getRequestedPosts() async {
    final allPosts = await getHistoryPosts();
    return allPosts.where((post) => post.postType == PostType.request).toList();
  }

  static Future<List<PostEntity>> getOfferedPosts() async {
    final allPosts = await getHistoryPosts();
    return allPosts.where((post) => post.postType == PostType.offer).toList();
  }

 
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
