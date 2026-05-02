import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/domain/usecases/sginup_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SginupUsecase sginUseCase;

  RegisterBloc({required this.sginUseCase}) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    try {
      final result = await sginUseCase(event.user);

  
      if (isClosed) return;

      result.fold(
        (failure) => emit(RegisterError(message: failure.message)),
        (_) => emit(const RegisterSuccess()),
      );
    } catch (e) {
    
      if (isClosed) return;

      emit(RegisterError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
