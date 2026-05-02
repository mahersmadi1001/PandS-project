part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final UserEntity user;
  const RegisterSubmitted({required this.user});
  @override
  List<Object> get props => [user];
}