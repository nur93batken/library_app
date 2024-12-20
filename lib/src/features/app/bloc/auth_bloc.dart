import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authPkg;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/src/features/authentication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

const _emailKey = 'email-key';
const _passwordKey = 'password-key';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.auth,
    required this.storage,
    required this.db,
  }) : super(UnauthenticatedState()) {
    on<AuthEvent>((event, emit) {});
    on<AuthLoginEvent>(_login);
    on<AuthRegisterEvent>(_register);
    on<AuthLogoutEvent>(_logout);
    on<AuthInitialEvent>(_init);
  }

  final authPkg.FirebaseAuth auth;
  final SharedPreferences storage;
  final FirebaseFirestore db;

  Future<void> _init(AuthInitialEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final email = storage.getString(_emailKey);
      final password = storage.getString(_passwordKey);

      if (email != null && password != null) {
        final fUser = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // log('$fUser');

        final appUser = User(
          email: email,
          password: password,
          uid: fUser.user?.uid ?? '',
        );

        emit(AuthenticatedState(appUser));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      final fUser = await auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      log('$fUser');

      final appUser = User(
        email: event.email,
        password: event.password,
        uid: fUser.user?.uid ?? '',
      );

      await storage.setString(_emailKey, event.email);
      await storage.setString(_passwordKey, event.password);

      emit(AuthenticatedState(appUser));
    } catch (e) {
      log('$e');
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _register(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());

      final fUser = await auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      log('firebase user uid ${fUser.user?.uid}');

      log('$fUser');

      final appUser = User(
        email: event.email,
        password: event.password,
        uid: fUser.user?.uid ?? '',
      );

      await db.collection("users").doc(appUser.uid).set(appUser.toJson());

      await storage.setString(_emailKey, event.email);
      await storage.setString(_passwordKey, event.password);

      emit(AuthenticatedState(appUser));
    } catch (e) {
      log('$e');
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _logout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoadingState());
      await Future.delayed(const Duration(seconds: 1));
      await auth.signOut();

      await storage.remove(_emailKey);
      await storage.remove(_passwordKey);

      emit(UnauthenticatedState());
    } catch (e) {
      log('$e');
      emit(AuthErrorState(e.toString()));
    }
  }
}
