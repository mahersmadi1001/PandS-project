import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/usecases/get_posts_usecase.dart';

part 'get_posts_event.dart';
part 'get_posts_state.dart';

class GetPostsBloc extends Bloc<GetPostsEvent, GetPostsState> {
  final GetPostsUsecase getPostsUsecase;

  GetPostsBloc({required this.getPostsUsecase})
    : super(const GetPostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<RefreshPosts>(_onRefreshPosts);
    on<FilterPosts>(_onFilterPosts);
    on<SearchPosts>(_onSearchPosts);
  }

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<GetPostsState> emit,
  ) async {
    emit(const GetPostsLoading());

    try {
      final result = await getPostsUsecase.call(
        postType: event.postType,
        category: event.category,
        searchQuery: event.searchQuery,
        province: event.province,
      );

      if (isClosed) return;

      result.fold(
        (failure) => emit(GetPostsFailure(message: failure.message)),
        (posts) => emit(GetPostsLoaded(posts: posts)),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        GetPostsFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<GetPostsState> emit,
  ) async {
    if (state is GetPostsLoaded) {
      final currentState = state as GetPostsLoaded;
      emit(GetPostsLoading(refreshing: true));

      try {
        final result = await getPostsUsecase.call(
          postType: event.postType ?? currentState.postType,
          category: event.category ?? currentState.category,
          searchQuery: event.searchQuery ?? currentState.searchQuery,
          province: event.province ?? currentState.province,
        );

        if (isClosed) return;

        result.fold(
          (failure) => emit(GetPostsFailure(message: failure.message)),
          (posts) => emit(
            GetPostsLoaded(
              posts: posts,
              postType: event.postType ?? currentState.postType,
              category: event.category ?? currentState.category,
              searchQuery: event.searchQuery ?? currentState.searchQuery,
              province: event.province ?? currentState.province,
            ),
          ),
        );
      } catch (e) {
        if (isClosed) return;
        emit(GetPostsLoaded(posts: currentState.posts));
      }
    } else {
      add(
        FetchPosts(
          postType: event.postType,
          category: event.category,
          searchQuery: event.searchQuery,
          province: event.province,
        ),
      );
    }
  }

  Future<void> _onFilterPosts(
    FilterPosts event,
    Emitter<GetPostsState> emit,
  ) async {
    add(
      FetchPosts(
        postType: event.postType,
        category: event.category,
        searchQuery: null,
        province: event.province,
      ),
    );
  }

  Future<void> _onSearchPosts(
    SearchPosts event,
    Emitter<GetPostsState> emit,
  ) async {
    if (state is GetPostsLoaded) {
      final currentState = state as GetPostsLoaded;

      // إذا كان البحث فارغًا، استخدم الفلاتر الحالية
      if (event.searchQuery.trim().isEmpty) {
        add(
          FetchPosts(
            postType: currentState.postType,
            category: currentState.category,
            searchQuery: null,
            province: currentState.province,
          ),
        );
      } else {
        // قم بالبحث مع الفلاتر الحالية
        add(
          FetchPosts(
            postType: currentState.postType,
            category: currentState.category,
            searchQuery: event.searchQuery,
            province: currentState.province,
          ),
        );
      }
    } else {
      add(FetchPosts(searchQuery: event.searchQuery));
    }
  }
}
