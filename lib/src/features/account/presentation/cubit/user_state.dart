// Состояния Cubit
import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/entities.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitialState extends UserState {}

class BookRentedState extends UserState {
  final List<Book> rentedBooks;

  BookRentedState(this.rentedBooks);

  @override
  List<Object?> get props => [rentedBooks];
}

// События Cubit
abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RentBookEvent extends BookEvent {
  final Book book;

  RentBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class ReturnBookEvent extends BookEvent {
  final Book book;

  ReturnBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}
