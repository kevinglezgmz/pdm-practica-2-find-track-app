import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practica_2_kevin_gonzalez/blocs/auth_bloc/auth_repository.dart';
import 'package:practica_2_kevin_gonzalez/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  UserModel? _me;
  UserModel? get me => _me;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthEmailLoginEvent>(_initiatePasswordLoginEventHandler);
    on<AuthGoogleLoginEvent>(_initiateGoogleLoginEventHandler);
    on<AuthEmailSignupEvent>(_initiateEmailSignupEventHandler);
    on<AuthCheckLoginStatusEvent>(_checkLoginStatusEventHandler);
    on<AuthSignoutEvent>(_signoutEventHandler);
  }

  FutureOr<void> _initiatePasswordLoginEventHandler(
      AuthEmailLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    try {
      final UserModel user =
          await _authRepository.signInWithEmail(event.email, event.password);
      _me = user;
      emit(AuthLoggedInState(me: user));
    } catch (e) {
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _initiateGoogleLoginEventHandler(
      AuthGoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    try {
      final UserModel user = await _authRepository.signInWithGoogle();
      _me = user;
      emit(AuthLoggedInState(me: user));
    } catch (e) {
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _initiateEmailSignupEventHandler(
      AuthEmailSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    try {
      final UserModel user = await _authRepository.signUpWithEmail(
          event.email, event.password, event.username);
      _me = user;
      emit(AuthLoggedInState(me: user));
    } catch (e) {
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _checkLoginStatusEventHandler(
      AuthCheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    User? meUser = FirebaseAuth.instance.currentUser;
    if (meUser != null) {
      emit(AuthLoggingInState());
    }
    UserModel? user = await _authRepository.getMeUser();
    if (user == null) {
      emit(AuthNotLoggedInState());
      return;
    }
    _me = user;
    emit(AuthLoggedInState(me: user));
  }

  FutureOr<void> _signoutEventHandler(
      AuthSignoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    await _authRepository.signOutFirebaseUser();
    emit(AuthNotLoggedInState());
  }
}
