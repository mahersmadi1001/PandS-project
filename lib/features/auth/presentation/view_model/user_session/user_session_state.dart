part of 'user_session_bloc.dart';

abstract class UserSessionState extends Equatable {
  const UserSessionState();
  @override
  List<Object> get props => [];
}

class UserSessionInitial extends UserSessionState {
  const UserSessionInitial();
}


class UserSessionLoading extends UserSessionState {
  const UserSessionLoading();
}


class UserFirstTimeState extends UserSessionState {
  const UserFirstTimeState();
}


class UserAuthenticated extends UserSessionState {
  const UserAuthenticated();
}


class UserUnAuth extends UserSessionState {
  const UserUnAuth();
}