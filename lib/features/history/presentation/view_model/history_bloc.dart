import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/usecases/get_posts_usecase.dart';
import 'package:p/features/create_and_view_post/domain/repositories/post_repository.dart';
import 'package:p/features/create_and_view_post/data/models/post_model.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetPostsUsecase getPostsUsecase;
  final AuthLocalDataSource authLocalDataSource;
  final FirebaseFirestore firestore;
  final PostRepository postRepository;

  StreamSubscription<QuerySnapshot>? _postsSubscription;

  HistoryBloc({
    required this.getPostsUsecase,
    required this.authLocalDataSource,
    required this.firestore,
    required this.postRepository,
  }) : super(const HistoryInitial()) {
    on<SavePostToHistory>(_onSavePostToHistory);
    on<GetHistoryPosts>(_onGetHistoryPosts);
    on<ClearHistory>(_onClearHistory);
    on<RemoveFromHistory>(_onRemoveFromHistory);
    on<DeletePost>(_onDeletePost);
    on<HistoryPostDeleted>(_onHistoryPostDeleted);
    on<LoadHistoryPosts>(_onLoadHistoryPosts);
    on<LoadHistoryError>(_onLoadHistoryError);
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSavePostToHistory(
    SavePostToHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      // Post is already saved to Firestore in CreatePostBloc
      // Just trigger a refresh to load updated history
      add(const GetHistoryPosts());
    } catch (e) {
      print(e);
      emit(HistoryError(message: e.toString()));
    }
  }

  Future<void> _onGetHistoryPosts(
    GetHistoryPosts event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      // Get current user ID
      final userId = await authLocalDataSource.getSession();
      if (userId == null) {
        emit(const HistoryError(message: 'User not logged in'));
        return;
      }

      // Cancel any existing subscription
      await _postsSubscription?.cancel();

      // Load initial data first
      final result = await getPostsUsecase(
        postType: null,
        category: null,
        searchQuery: null,
        province: null,
        userId: userId,
      );

      if (isClosed) return;

      result.fold((failure) => emit(HistoryError(message: failure.message)), (
        posts,
      ) {
        emit(HistoryLoaded(posts: posts));

        // Set up real-time listener after initial load
        _postsSubscription = firestore
            .collection('posts')
            .where('creator_id', isEqualTo: userId)
            .limit(100)
            .snapshots()
            .listen(
              (snapshot) {
                if (isClosed) return;

                // Sort client-side to avoid index issues
                final updatedPosts =
                    snapshot.docs
                        .map((doc) => PostModel.fromMap(doc.data()))
                        .toList()
                      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                // Use add instead of emit to avoid completion issues
                add(LoadHistoryPosts(posts: updatedPosts));
              },
              onError: (error) {
                if (isClosed) return;
                print(error);
                add(LoadHistoryError(message: error.toString()));
              },
            );
      });
    } catch (e) {
      print(e);
      if (!isClosed) {
        emit(HistoryError(message: e.toString()));
      }
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      // Clear history by loading empty posts
      final userId = await authLocalDataSource.getSession();
      if (userId == null) {
        emit(const HistoryError(message: 'User not logged in'));
        return;
      }

      final result = await getPostsUsecase(
        postType: null,
        category: null,
        searchQuery: null,
        province: null,
        userId: userId,
      );

      if (isClosed) return;

      result.fold(
        (failure) => emit(HistoryError(message: failure.message)),
        (posts) => emit(HistoryLoaded(posts: [])), // Empty history
      );
    } catch (e) {
      print(e);
      if (!isClosed) {
        emit(HistoryError(message: e.toString()));
      }
    }
  }

  Future<void> _onRemoveFromHistory(
    RemoveFromHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      // Remove by reloading posts ( Firestore doesn't support delete by postId directly)
      add(const GetHistoryPosts());
    } catch (e) {
      print(e);
      emit(HistoryError(message: e.toString()));
    }
  }

  Future<void> _onDeletePost(
    DeletePost event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      // Get current user ID to verify ownership
      final userId = await authLocalDataSource.getSession();
      if (userId == null) {
        emit(const HistoryError(message: 'User not logged in'));
        return;
      }

      // Delete post from Firestore
      final result = await postRepository.deletePost(event.postId);

      if (isClosed) return;

      result.fold((failure) => emit(HistoryError(message: failure.message)), (
        _,
      ) async {
        add(const HistoryPostDeleted());
        // Add small delay before reload to avoid handler conflicts
        await Future.delayed(Duration(milliseconds: 100));
        if (!isClosed) {
          add(const GetHistoryPosts());
        }
      });
    } catch (e) {
      print(e);
      if (!isClosed) {
        emit(HistoryError(message: e.toString()));
      }
    }
  }

  Future<void> _onHistoryPostDeleted(
    HistoryPostDeleted event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryPostDeletionSuccess());
  }

  Future<void> _onLoadHistoryPosts(
    LoadHistoryPosts event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoaded(posts: event.posts));
  }

  Future<void> _onLoadHistoryError(
    LoadHistoryError event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryError(message: event.message));
  }
}
