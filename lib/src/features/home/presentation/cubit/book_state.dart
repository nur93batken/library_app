import '../../data/models/book.dart';

class BookState {
  final List<Book> allBooks;
  final List<Book> filteredBooks;

  BookState({required this.allBooks, required this.filteredBooks});
}

class BookInitial extends BookState {
  BookInitial({required super.allBooks, required super.filteredBooks});
}
