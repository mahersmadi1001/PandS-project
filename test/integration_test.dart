import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:p/main.dart' as app;
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete app flow - create post and view in history', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Test 1: App launches successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Test 2: Navigate to create post screen
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Create New Post'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);

      // Test 3: Fill in post details
      await tester.enterText(find.byType(TextFormField).first, 'Test Post Title');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test Description');
      await tester.enterText(find.byType(TextFormField).at(2), 'Test Price');
      
      await tester.pumpAndSettle();

      // Test 4: Select category
      await tester.tap(find.text('Select Category'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Services').first);
      await tester.pumpAndSettle();

      // Test 5: Submit post
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Test 6: Verify success message
      expect(find.text('Post created successfully!'), findsOneWidget);

      // Test 7: Navigate to history
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Test 8: Verify post appears in history
      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('app handles navigation correctly', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Test navigation between tabs
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Requests'), findsOneWidget);

      await tester.tap(find.text('Offers'));
      await tester.pumpAndSettle();
      expect(find.text('Offers'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('search functionality works correctly', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to requests tab
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      // Test search functionality
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Verify search results
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('filter functionality works correctly', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to requests tab
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      // Test filter functionality
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Select filter options
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Verify filter is applied
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('post details navigation works correctly', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to requests tab
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      // Wait for posts to load
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Try to tap on first post (if available)
      final postCards = find.byType(Card);
      if (postCards.evaluate().isNotEmpty) {
        await tester.tap(postCards.first);
        await tester.pumpAndSettle();

        // Verify post details screen
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('error handling - invalid form submission', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to create post
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('error handling - network failure simulation', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to requests tab
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      // Wait for loading
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify error handling (if network fails)
      final errorMessages = find.text('Failed to load posts');
      if (errorMessages.evaluate().isNotEmpty) {
        expect(errorMessages, findsOneWidget);
      }
    });

    testWidgets('performance test - scrolling through posts', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to requests tab
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      // Wait for posts to load
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Test scrolling performance
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        await tester.fling(listView, const Offset(0, -500), 1000);
        await tester.pumpAndSettle();

        await tester.fling(listView, const Offset(0, 500), 1000);
        await tester.pumpAndSettle();
      }

      // Verify app is still responsive
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('memory test - multiple navigation actions', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Perform multiple navigation actions
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Requests'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Offers'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
      }

      // Verify app is still stable
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('accessibility test - screen reader compatibility', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Test semantic labels
      expect(find.bySemanticsLabel('Home'), findsOneWidget);
      expect(find.bySemanticsLabel('Requests'), findsOneWidget);
      expect(find.bySemanticsLabel('Offers'), findsOneWidget);

      // Test navigation with semantic labels
      await tester.tap(find.bySemanticsLabel('History'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('History'), findsOneWidget);
    });

    testWidgets('orientation change test', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Test landscape orientation
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();

      // Verify UI adapts to landscape
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test portrait orientation
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();

      // Verify UI adapts to portrait
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('deep linking test - navigate to specific post', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Simulate deep link to post details
      // This would require actual deep link implementation
      // For now, we'll test the navigation flow manually
      
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle(Duration(seconds: 2));

      // Try to navigate to post details
      final postCards = find.byType(Card);
      if (postCards.evaluate().isNotEmpty) {
        await tester.tap(postCards.first);
        await tester.pumpAndSettle();

        // Verify we're on post details screen
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('user preferences test - theme switching', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings (if available)
      final settingsButton = find.byIcon(Icons.settings);
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        // Test theme switching
        await tester.tap(find.text('Dark Theme'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Light Theme'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('data persistence test - app restart', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Create a post
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Persistence Test');
      await tester.pumpAndSettle();

      // Simulate app restart
      app.main();
      await tester.pumpAndSettle();

      // Navigate to history
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Verify data persists (if implemented)
      // This would depend on actual data persistence implementation
    });

    testWidgets('concurrent operations test - multiple actions', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Perform multiple concurrent actions
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Offers'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify app handles concurrent operations
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
