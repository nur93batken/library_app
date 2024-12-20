part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  HomeSuccess(this.users);
  final List<User> users;
}

final class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}
