part of 'user_session_bloc.dart';

abstract class UserSessionEvent extends Equatable {
  const UserSessionEvent();
  @override
  List<Object> get props => [];
}


class UserSessionCheckStatus extends UserSessionEvent {
  const UserSessionCheckStatus();
}


class CompleteOnboarding extends UserSessionEvent {
  const CompleteOnboarding();
}


class LogoutUser extends UserSessionEvent {
  const LogoutUser();
}