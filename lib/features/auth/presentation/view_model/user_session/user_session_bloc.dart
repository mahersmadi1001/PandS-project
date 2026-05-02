import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p/features/auth/data/datasources/local.dart';

part 'user_session_event.dart';
part 'user_session_state.dart';

class UserSessionBloc extends Bloc<UserSessionEvent, UserSessionState> {
  final AuthLocalDataSource localDataSource;

  UserSessionBloc({required this.localDataSource})
    : super(const UserSessionInitial()) {
    on<UserSessionCheckStatus>(_onCheckStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<LogoutUser>(_onLogout);
  }

  Future<void> _onCheckStatus(
    UserSessionCheckStatus event,
    Emitter<UserSessionState> emit,
  ) async {
    emit(const UserSessionLoading());

    await Future.delayed(const Duration(seconds: 2)); 

    if (localDataSource.isFirstTimeOpen()) {
     
      emit(const UserFirstTimeState());
    } else if (localDataSource.hasSession()) {
  
      emit(const UserAuthenticated());
    } else {
   
      emit(const UserUnAuth());
    }
  }
 Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<UserSessionState> emit,
  ) async {
    await localDataSource.completeOnboarding();
    emit(const UserUnAuth()); 
  }


  Future<void> _onLogout(
    LogoutUser event,
    Emitter<UserSessionState> emit,
  ) async {
    await localDataSource.clearSession();
    emit(const UserUnAuth());
  }
}
