part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();
  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية — النموذج فارغ
class CreatePostInitial extends CreatePostState {
  const CreatePostInitial();
}

/// جارٍ تحميل بيانات المستخدم
class CreatePostLoadingUser extends CreatePostState {
  const CreatePostLoadingUser();
}

/// تم تحميل بيانات المستخدم بنجاح
class CreatePostUserLoaded extends CreatePostState {
  final String userId;
  final String userName;
  const CreatePostUserLoaded({required this.userId, required this.userName});
  @override
  List<Object?> get props => [userId, userName];
}

/// جارٍ رفع الصورة على Supabase
class CreatePostUploadingImage extends CreatePostState {
  const CreatePostUploadingImage();
}

/// جارٍ حفظ المنشور في Firestore
class CreatePostSaving extends CreatePostState {
  const CreatePostSaving();
}

/// تم النشر بنجاح
class CreatePostSuccess extends CreatePostState {
  const CreatePostSuccess();
}

/// فشل النشر
class CreatePostFailure extends CreatePostState {
  final String message;
  const CreatePostFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
