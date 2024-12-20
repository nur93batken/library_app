part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthenticatedState extends AuthState {
  AuthenticatedState(this.user);

  final User user;
}

final class UnauthenticatedState extends AuthState {}

final class AuthErrorState extends AuthState {
  AuthErrorState(this.message);
  final String message;
}

final class AuthLoadingState extends AuthState {}
