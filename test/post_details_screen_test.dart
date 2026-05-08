import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

void main() {
  group('PostDetailsScreen Tests', () {
    late PostEntity testPost;

    setUp(() {
      testPost = PostEntity(
        postId: 'test_post_id',
        creatorId: 'test_user_id',
        creatorName: 'Test User',
        postType: PostType.offer,
        category: 'electronics',
        title: 'Test Product',
        description: 'Test Description',
        province: 'Damascus',
        price: '100',
        image: 'test_image_url',
        createdAt: '2023-01-01',
      );
    });

    testWidgets('should display post details correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(home: PostDetailsScreen(post: testPost, isRequest: false)),
      );

      // Wait for async operations
      await tester.pumpAndSettle();

      // Assert basic post information
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('100 \$'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget); // Creator name from post
      expect(find.text('electronics'), findsOneWidget); // Category
      expect(find.text('Damascus'), findsOneWidget); // Province
      expect(find.text('عرض'), findsOneWidget); // Post type (offer)
      expect(
        find.text('معلومات التواصل'),
        findsOneWidget,
      ); // Contact section title
    });

    testWidgets('should display request type correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(home: PostDetailsScreen(post: testPost, isRequest: true)),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('طلب'), findsOneWidget); // Post type (request)
    });
  });
}
