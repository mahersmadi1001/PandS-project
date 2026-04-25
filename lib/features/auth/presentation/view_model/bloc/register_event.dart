part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class SginupEvent extends RegisterEvent {
  final UserEntity user;
  SginupEvent({required this.user});
  @override
  List<Object> get props => [user];
}
