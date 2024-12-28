import '../../../authentication/models/user_model.dart';

class UserState {
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  UserState({this.user, this.errorMessage, this.isLoading = false});

  UserState copyWith({
    User? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
