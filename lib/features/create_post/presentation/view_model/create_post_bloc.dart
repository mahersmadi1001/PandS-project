import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/create_post/domain/entities/post_entity.dart';
import 'package:p/features/create_post/domain/usecases/create_post_usecase.dart';
import 'package:uuid/uuid.dart';


part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePostUsecase createPostUsecase;

  CreatePostBloc({required this.createPostUsecase})
      : super(const CreatePostInitial()) {
    on<CreatePostSubmitted>(_onCreatePostSubmitted);
  }

  Future<void> _onCreatePostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {

    emit(const CreatePostUploadingImage());

   
    final String postId = const Uuid().v4();
    final String createdAt = DateTime.now().toIso8601String();

    final PostEntity post = PostEntity(
      postId:      postId,
      creatorId:   event.creatorId,
      creatorName: event.creatorName,
      postType:    event.postType,
      category:    event.category,
      description: event.description,
      province:    event.province,
      price:       event.price,
      image:       '',            
      createdAt:   createdAt,
    );

    try {
   
      emit(const CreatePostSaving());

      final result = await createPostUsecase(
        post:      post,
        imageFile: event.imageFile,
      );

      if (isClosed) return;

      result.fold(
        (failure) => emit(CreatePostFailure(message: failure.message)),
        (_)       => emit(const CreatePostSuccess()),
      );
    } catch (e) {
      if (isClosed) return;
      emit(CreatePostFailure(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
