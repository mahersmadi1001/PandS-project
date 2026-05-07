import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:p/core/services/history_service.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

// Generate mocks
@GenerateMocks([Box])
import 'unit_test.mocks.dart';

void main() {
  group('HistoryService Unit Tests', () {
    late MockBox mockBox;

    setUp(() {
      mockBox = MockBox();
    });

    group('savePostToHistory', () {
      test('should save post successfully when Hive operations work', () async {
        // Arrange
        final testPost = PostEntity(
          postId: 'test123',
          creatorId: 'user123',
          creatorName: 'Test User',
          postType: PostType.request,
          category: 'Test Category',
          description: 'Test Description',
          province: 'Test Province',
          price: '100',
          image: 'test_image.jpg',
          createdAt: '2023-01-01T00:00:00.000Z',
        );

        // Mock existing history list
        final existingHistory = [
          {
            'postId': 'old123',
            'creatorId': 'oldUser',
            'creatorName': 'Old User',
            'postType': 'request',
            'category': 'Old Category',
            'description': 'Old Description',
            'province': 'Old Province',
            'price': '50',
            'image': 'old_image.jpg',
            'createdAt': '2022-01-01T00:00:00.000Z',
          },
        ];

        when(
          mockBox.get('user_history'),
        ).thenReturn(jsonEncode(existingHistory));
        when(mockBox.put(any, any)).thenAnswer((_) async {});

        // Act
        await HistoryService.savePostToHistory(testPost);

        // Assert
        verify(mockBox.put('user_history', any)).called(1);

        // Verify the new post is added to the beginning
        final capturedPut = verify(
          mockBox.put('user_history', captureAny),
        ).captured.first;
        final updatedHistory = jsonDecode(capturedPut) as List;

        expect(updatedHistory.length, 2);
        expect(updatedHistory.first['postId'], 'test123');
        expect(updatedHistory.first['creatorName'], 'Test User');
      });

      test('should handle Hive exception gracefully', () async {
        // Arrange
        final testPost = PostEntity(
          postId: 'test123',
          creatorId: 'user123',
          creatorName: 'Test User',
          postType: PostType.request,
          category: 'Test Category',
          description: 'Test Description',
          province: 'Test Province',
          price: '100',
          image: 'test_image.jpg',
          createdAt: '2023-01-01T00:00:00.000Z',
        );

        when(mockBox.get('user_history')).thenThrow(Exception('Hive error'));

        // Act & Assert
        // Should not throw exception
        await HistoryService.savePostToHistory(testPost);

        // Should attempt to get the history
        verify(mockBox.get('user_history')).called(1);
      });

      test('should limit history to 50 posts', () async {
        // Arrange
        final testPost = PostEntity(
          postId: 'test123',
          creatorId: 'user123',
          creatorName: 'Test User',
          postType: PostType.request,
          category: 'Test Category',
          description: 'Test Description',
          province: 'Test Province',
          price: '100',
          image: 'test_image.jpg',
          createdAt: '2023-01-01T00:00:00.000Z',
        );

        // Create 50 existing posts
        final existingHistory = List.generate(
          50,
          (index) => {
            'postId': 'post$index',
            'creatorId': 'user$index',
            'creatorName': 'User $index',
            'postType': 'request',
            'category': 'Category $index',
            'description': 'Description $index',
            'province': 'Province $index',
            'price': '$index',
            'image': 'image$index.jpg',
            'createdAt': '2023-01-01T00:00:00.000Z',
          },
        );

        when(
          mockBox.get('user_history'),
        ).thenReturn(jsonEncode(existingHistory));
        when(mockBox.put(any, any)).thenAnswer((_) async {});

        // Act
        await HistoryService.savePostToHistory(testPost);

        // Assert
        final capturedPut = verify(
          mockBox.put('user_history', captureAny),
        ).captured.first;
        final updatedHistory = jsonDecode(capturedPut) as List;

        expect(updatedHistory.length, 50); // Should still be 50, not 51
        expect(
          updatedHistory.first['postId'],
          'test123',
        ); // New post should be first
      });
    });

    group('getHistoryPosts', () {
      test('should return posts when history exists', () async {
        // Arrange
        final historyData = [
          {
            'postId': 'test123',
            'creatorId': 'user123',
            'creatorName': 'Test User',
            'postType': 'request',
            'category': 'Test Category',
            'description': 'Test Description',
            'province': 'Test Province',
            'price': '100',
            'image': 'test_image.jpg',
            'createdAt': '2023-01-01T00:00:00.000Z',
          },
        ];

        when(mockBox.get('user_history')).thenReturn(jsonEncode(historyData));

        // Act
        final result = await HistoryService.getHistoryPosts();

        // Assert
        expect(result.length, 1);
        expect(result.first.postId, 'test123');
        expect(result.first.creatorName, 'Test User');
        expect(result.first.postType, PostType.request);
      });

      test('should return empty list when no history exists', () async {
        // Arrange
        when(mockBox.get('user_history')).thenReturn(null);

        // Act
        final result = await HistoryService.getHistoryPosts();

        // Assert
        expect(result.isEmpty, isTrue);
      });

      test('should handle invalid JSON gracefully', () async {
        // Arrange
        when(mockBox.get('user_history')).thenReturn('invalid json');

        // Act
        final result = await HistoryService.getHistoryPosts();

        // Assert
        expect(result.isEmpty, true);
      });

      test('should handle Hive exception gracefully', () async {
        // Arrange
        when(mockBox.get('user_history')).thenThrow(Exception('Hive error'));

        // Act
        final result = await HistoryService.getHistoryPosts();

        // Assert
        expect(result.isEmpty, true);
      });
    });

    group('removeFromHistory', () {
      test('should remove post successfully when it exists', () async {
        // Arrange
        final historyData = [
          {
            'postId': 'test123',
            'creatorId': 'user123',
            'creatorName': 'Test User',
            'postType': 'request',
            'category': 'Test Category',
            'description': 'Test Description',
            'province': 'Test Province',
            'price': '100',
            'image': 'test_image.jpg',
            'createdAt': '2023-01-01T00:00:00.000Z',
          },
          {
            'postId': 'test456',
            'creatorId': 'user456',
            'creatorName': 'Test User 2',
            'postType': 'offer',
            'category': 'Test Category 2',
            'description': 'Test Description 2',
            'province': 'Test Province 2',
            'price': '200',
            'image': 'test_image2.jpg',
            'createdAt': '2023-01-02T00:00:00.000Z',
          },
        ];

        when(mockBox.get('user_history')).thenReturn(jsonEncode(historyData));
        when(mockBox.put(any, any)).thenAnswer((_) async {});

        // Act
        await HistoryService.removeFromHistory('test123');

        // Assert
        verify(mockBox.put('user_history', any)).called(1);

        final capturedPut = verify(
          mockBox.put('user_history', captureAny),
        ).captured.first;
        final updatedHistory = jsonDecode(capturedPut) as List;

        expect(updatedHistory.length, 1);
        expect(updatedHistory.first['postId'], 'test456');
      });

      test('should handle removing non-existent post', () async {
        // Arrange
        final historyData = [
          {
            'postId': 'test123',
            'creatorId': 'user123',
            'creatorName': 'Test User',
            'postType': 'request',
            'category': 'Test Category',
            'description': 'Test Description',
            'province': 'Test Province',
            'price': '100',
            'image': 'test_image.jpg',
            'createdAt': '2023-01-01T00:00:00.000Z',
          },
        ];

        when(mockBox.get('user_history')).thenReturn(jsonEncode(historyData));
        when(mockBox.put(any, any)).thenAnswer((_) async {});

        // Act
        await HistoryService.removeFromHistory('nonexistent');

        // Assert
        verify(mockBox.put('user_history', any)).called(1);

        final capturedPut = verify(
          mockBox.put('user_history', captureAny),
        ).captured.first;
        final updatedHistory = jsonDecode(capturedPut) as List;

        expect(updatedHistory.length, 1); // Should remain unchanged
      });

      test('should handle Hive exception during removal', () async {
        // Arrange
        when(mockBox.get('user_history')).thenThrow(Exception('Hive error'));

        // Act & Assert
        // Should not throw exception
        await HistoryService.removeFromHistory('test123');

        verify(mockBox.get('user_history')).called(1);
      });
    });
  });
}
