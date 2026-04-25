// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:p/features/auth/domain/entities/user.dart';

import 'package:p/features/auth/domain/usecases/sginup_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SginupUsecase sginUseCase;

  RegisterBloc({required this.sginUseCase}) : super(RegisterInitial()) {
    on<SginupEvent>((event, emit) async {
      emit(RegisterLoading());
      final result = await sginUseCase(event.user);
      result.fold(
        (failuer) {
          emit(RegisterError(massege: failuer.message));
        },
        (_) async {
          emit(RegisterSucssfoled());
        },
      );
    });
  }
}
