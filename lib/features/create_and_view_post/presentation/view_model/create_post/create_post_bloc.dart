import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/core/services/history_service.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/domain/usecases/create_post_usecase.dart';
import 'package:p/features/auth/domain/usecases/get_saved_session_usecase.dart';
import 'package:uuid/uuid.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUsecase createPostUsecase;
  final GetSavedSessionUsecase getSavedSessionUsecase;
  final HistoryService historyService;

  CreatePostBloc({
    required this.createPostUsecase,
    required this.getSavedSessionUsecase,
  }) : historyService = HistoryService(),
       super(const CreatePostInitial()) {
    on<CreatePostSubmitted>(_onCreatePostSubmitted);
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(const CreatePostLoadingUser());

    try {
      final result = await getSavedSessionUsecase();

      result.fold(
        (failure) => emit(CreatePostFailure(message: failure.message)),
        (userEntity) {
          if (userEntity != null) {
            emit(
              CreatePostUserLoaded(
                userId: userEntity.uId,
                userName: userEntity.fullName,
              ),
            );
          } else {
            emit(const CreatePostFailure(message: 'No user session found'));
          }
        },
      );
    } catch (e) {
      emit(
        CreatePostFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onCreatePostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(const CreatePostUploadingImage());

    final String postId = const Uuid().v4();
    final String createdAt = DateTime.now().toIso8601String();

    final PostEntity post = PostEntity(
      postId: postId,
      creatorId: event.creatorId,
      creatorName: event.creatorName,
      postType: event.postType,
      category: event.category,
      description: event.description,
      province: event.province,
      price: event.price,
      image: '',
      createdAt: createdAt,
    );

    try {
      emit(const CreatePostSaving());

      final result = await createPostUsecase(
        post: post,
        imageFile: event.imageFile,
      );

      if (isClosed) return;

      result.fold(
        (failure) => emit(CreatePostFailure(message: failure.message)),
        (imageUrl) async {
          // Create post entity with image URL
          final completePost = PostEntity(
            postId: postId,
            creatorId: event.creatorId,
            creatorName: event.creatorName,
            postType: event.postType,
            category: event.category,
            description: event.description,
            province: event.province,
            price: event.price,
            image: imageUrl,
            createdAt: createdAt,
          );

          // Save to history
          await HistoryService.savePostToHistory(completePost);

          emit(const CreatePostSuccess());
          return const CreatePostSuccess();
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        CreatePostFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
