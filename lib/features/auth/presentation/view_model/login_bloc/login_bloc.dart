import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/usecases/usecase_login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final result = await loginUsecase(
        email: event.email,
        password: event.password,
      );

      if (isClosed) return;

      result.fold(
        (failure) => emit(LoginError(message: failure.message)),
        (user) => emit(LoginSuccess(user: user)),
      );
    } catch (e) {
      if (isClosed) return;

      emit(LoginError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
