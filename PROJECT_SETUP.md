# PandS Project Documentation

## 📋 Project Overview
PandS (Posts and Services) is a Flutter application that allows users to create, view, and manage service requests and offers. The app follows Clean Architecture principles with BLoC pattern for state management.

## 🏗️ Architecture

### Clean Architecture Layers
- **Presentation Layer**: UI components, BLoCs, and screens
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

### Key Components
- **BLoC Pattern**: State management using flutter_bloc
- **Firebase/Firestore**: Backend for post storage
- **Supabase**: Image storage service
- **Hive**: Local storage for user sessions and history

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Firebase project configured
- Supabase project configured

### Environment Setup
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)
   - Update `lib/firebase_options.dart` with your Firebase config

4. Configure Supabase:
   - Update Supabase URL and anon key in `lib/main.dart`
   - Create storage bucket named 'posts'

5. Run the app:
   ```bash
   flutter run
   ```

## 📱 App Features

### Core Features
1. **User Authentication**
   - Login/Register with email and password
   - Session management using Hive

2. **Post Management**
   - Create requests and offers
   - Upload images to Supabase
   - Real-time post updates

3. **Search & Filter**
   - Text search in posts
   - Filter by province (single selection)
   - Filter by service category (multiple selection)
   - Animated filter chips with visual feedback

4. **Post Details**
   - Complete post information display
   - Contact details (email, phone)
   - Offer submission for requests

5. **History Management**
   - User's created posts history
   - Separate tabs for requests and offers
   - Local storage using Hive

## 🎨 UI Components

### Custom Widgets
- **PostCard**: Reusable post display with image and details
- **SearchFilterWidget**: Advanced search and filtering interface
- **PostDetailsScreen**: Full post information with contact options
- **SelectionButton**: Custom selection buttons
- **HistoryScreen**: User's post history management

### Design System
- **AppColors**: Centralized color scheme
- **ScreenUtil**: Responsive design
- **Material Design 3**: Modern UI components

## 🔧 Technical Implementation

### State Management
```dart
// Example BLoC usage
BlocProvider(
  create: (context) => sl<GetPostsBloc>(),
  child: PostListScreen(),
)
```

### Navigation
```dart
// Navigation to post details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PostDetailsScreen(
      post: post,
      isRequest: post.postType == PostType.request,
    ),
  ),
);
```

### Data Flow
1. User creates post → CreatePostBloc processes → Firebase/Supabase
2. Posts fetched → GetPostsBloc → UI updates
3. Search/Filter → GetPostsBloc → Filtered results
4. History save → HistoryService → Local storage

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/          # Dependency injection
│   ├── services/         # History service
│   ├── shared/
│   │   ├── widgets/      # Reusable UI components
│   │   └── helper/       # Validators and utilities
│   └── theme/           # App colors and themes
├── features/
│   ├── auth/            # Authentication features
│   └── create_post/     # Post creation and management
│       ├── domain/         # Business logic
│       ├── data/          # Data sources and repositories
│       └── presentation/   # UI and BLoCs
└── view_temp/            # Main app screens
```

## 🔍 Key Features Implementation

### Search & Filter System
- **Real-time search**: Debounced text input
- **Province filter**: Single selection with animated chips
- **Category filter**: Multiple selection with visual feedback
- **Filter persistence**: Maintains state across searches

### Post Creation Flow
1. User fills form → Validation using AppValidators
2. Image upload → Supabase storage
3. Post data → Firestore database
4. History save → Local Hive storage

### Real-time Updates
- **Time display**: Relative time formatting (منذ دقيقة/ساعة/يوم)
- **Live updates**: BLoC state changes
- **Visual feedback**: Loading states and error handling

## 🛠️ Development Guidelines

### Code Standards
- **Clean Architecture**: Separate layers with clear boundaries
- **BLoC Pattern**: Event-driven state management
- **Error Handling**: Comprehensive error states and messages
- **Responsive Design**: Using flutter_screenutil

### Best Practices
- Use dependency injection for all services
- Implement proper error states
- Follow Flutter/Dart naming conventions
- Write reusable widgets and utilities

## 🚀 Deployment

### Build Commands
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# iOS build
flutter build ios --release
```

### Environment Variables
- Firebase configuration in `firebase_options.dart`
- Supabase keys in `main.dart`
- Ensure all sensitive keys are properly secured

## 📞 Support

For any issues or questions:
1. Check the implementation follows Clean Architecture
2. Verify BLoC event/state flow
3. Ensure proper error handling
4. Test search and filter functionality
5. Validate navigation and state management

## 🔄 Future Enhancements

- Push notifications for new offers
- Chat functionality between users
- Rating system for completed services
- Advanced search with location-based filtering
- Multi-language support expansion

---

**Note**: This project demonstrates professional Flutter development with modern architecture patterns and best practices.
