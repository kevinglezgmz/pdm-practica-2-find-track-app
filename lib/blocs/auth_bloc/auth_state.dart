part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoggedInState extends AuthState {
  final UserModel me;

  const AuthLoggedInState({required this.me});

  @override
  List<Object> get props => [me];
}

class AuthNotLoggedInState extends AuthState {}

class AuthLoggingInState extends AuthState {}

class AuthSigningUpState extends AuthState {}

class AuthSignUpErrorState extends AuthState {}

class AuthLoginErrorState extends AuthState {}
