part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthEmailLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthGoogleLoginEvent extends AuthEvent {}

class AuthEmailSignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const AuthEmailSignupEvent({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthCheckLoginStatusEvent extends AuthEvent {}

class AuthSignoutEvent extends AuthEvent {}
