import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/post_card/post_card.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/views/post_details_screen.dart';

void main() {
  group('PostCard Widget Tests', () {
    // Test data
    final testPostWithImage = PostEntity(
      title: "test",
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

    final testPostWithoutImage = PostEntity(
      title: "test",
      postId: 'test456',
      creatorId: 'user456',
      creatorName: 'Test User 2',
      postType: PostType.offer,
      category: 'Test Category 2',
      description: 'Test Description 2',
      province: 'Test Province 2',
      price: '200',
      image: '',
      createdAt: '2023-01-02T00:00:00.000Z',
    );

    setUp(() {
      // ScreenUtil will be initialized in each test
    });

    testWidgets('should display PostCard with image correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool onTapCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage,
                  onTap: () => onTapCalled = true,
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Test Province'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Test tap functionality
      await tester.tap(find.byType(PostCard));
      await tester.pump();
      expect(onTapCalled, isTrue);
    });

    testWidgets('should display PostCard without image correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool onTapCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithoutImage,
                  onTap: () => onTapCalled = true,
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Test User 2'), findsOneWidget);
      expect(find.text('Test Description 2'), findsOneWidget);
      expect(find.text('Test Province 2'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.byType(Image), findsNothing); // No image should be present

      // Test tap functionality
      await tester.tap(find.byType(PostCard));
      await tester.pump();
      expect(onTapCalled, isTrue);
    });

    testWidgets('should navigate to PostDetailsScreen when onTap is null', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage,
                  onTap: null, // No custom onTap provided
                ),
              ),
            );
          },
        ),
      );

      // Act
      await tester.tap(find.byType(PostCard));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PostDetailsScreen), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should show offer button for request posts', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool onOfferTapCalled = false;

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage, // Request post
                  onOfferTap: () => onOfferTapCalled = true,
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(
        find.text('Offer'),
        findsOneWidget,
      ); // Offer button should be visible

      // Test offer tap functionality
      await tester.tap(find.text('Offer'));
      await tester.pump();
      expect(onOfferTapCalled, isTrue);
    });

    testWidgets('should not show offer button for offer posts', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithoutImage, // Offer post
                  onOfferTap: () {},
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(
        find.text('Offer'),
        findsNothing,
      ); // Offer button should not be visible
    });

    testWidgets('should handle long descriptions correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final longDescriptionPost = PostEntity(
        title: "test",
        postId: 'test789',
        creatorId: 'user789',
        creatorName: 'Test User 3',
        postType: PostType.request,
        category: 'Test Category 3',
        description:
            'This is a very long description that should be truncated or handled properly in the UI to prevent overflow and maintain good user experience',
        province: 'Test Province 3',
        price: '300',
        image: '',
        createdAt: '2023-01-03T00:00:00.000Z',
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(post: longDescriptionPost, onTap: () {}),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Test User 3'), findsOneWidget);
      // Should not overflow the screen
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle empty price correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyPricePost = PostEntity(
        title: "test",
        postId: 'test000',
        creatorId: 'user000',
        creatorName: 'Test User 4',
        postType: PostType.request,
        category: 'Test Category 4',
        description: 'Test Description 4',
        province: 'Test Province 4',
        price: '', // Empty price
        image: '',
        createdAt: '2023-01-04T00:00:00.000Z',
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(post: emptyPricePost, onTap: () {}),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Test User 4'), findsOneWidget);
      expect(find.text('Test Description 4'), findsOneWidget);
      // Should handle empty price gracefully
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display correct post type indicator', (
      WidgetTester tester,
    ) async {
      // Test request post
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage, // Request post
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      );

      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Request'), findsOneWidget); // Should show "Request"

      await tester.pumpWidget(Container()); // Clear previous widget

      // Test offer post
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithoutImage, // Offer post
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      );

      expect(find.byType(PostCard), findsOneWidget);
      expect(find.text('Offer'), findsOneWidget); // Should show "Offer"
    });

    testWidgets('should handle null onOfferTap gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage, // Request post
                  onTap: () {},
                  onOfferTap: null, // Null offer tap
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.byType(PostCard), findsOneWidget);
      expect(
        find.text('Offer'),
        findsOneWidget,
      ); // Offer button should still be visible

      // Tap should not throw exception
      await tester.tap(find.text('Offer'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain proper card styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(post: testPostWithImage, onTap: () {}),
              ),
            );
          },
        ),
      );

      // Assert
      final cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<Card>(cardFinder);
      expect(card.elevation, 10);
      expect(card.margin, const EdgeInsets.symmetric(horizontal: 16));
    });

    testWidgets('should handle rapid tap events', (WidgetTester tester) async {
      // Arrange
      int tapCount = 0;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: PostCard(
                  post: testPostWithImage,
                  onTap: () => tapCount++,
                ),
              ),
            );
          },
        ),
      );

      // Act - Rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(PostCard));
        await tester.pump();
      }

      // Assert
      expect(tapCount, 5);
      expect(tester.takeException(), isNull);
    });
  });
}
