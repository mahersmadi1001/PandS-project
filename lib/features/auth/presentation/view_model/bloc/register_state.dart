// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterError extends RegisterState {
  String massege;
  RegisterError({required this.massege});
}

class RegisterSucssfoled extends RegisterState {}
