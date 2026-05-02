part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final UserEntity user;
  const LoginSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});
  @override
  List<Object?> get props => [message];
}