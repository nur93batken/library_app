import '../../domain/entities/rentail.dart';

abstract class RentalState {}

class RentalInitial extends RentalState {}

class RentalLoading extends RentalState {}

class RentalSuccess extends RentalState {
  final Rental rental;

  RentalSuccess({required this.rental});
}

class RentalError extends RentalState {
  final String message;

  RentalError({required this.message});
}

class RentalListLoaded extends RentalState {
  final List<Rental> rentals;

  RentalListLoaded({required this.rentals});
}
