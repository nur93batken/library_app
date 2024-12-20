import '../../../home/domain/entities/entities.dart';

class User {
  String name;
  int id;
  List<Book> rentedBooks = [];

  // Конструктор
  User({required this.name, required this.id, this.rentedBooks = const []});

  // Метод: Китепти ижарага алуу
  void rentBook(Book book) {
    if (book.copyCount > 0) {
      rentedBooks.add(book);
      book.rentBook();
      print("Book '${book.gettitle}' rented successfully.");
    } else {
      print("Book '${book.gettitle}' is not available.");
    }
  }

  // Метод: Китепти кайтаруу
  void returnBook(Book book) {
    if (rentedBooks.contains(book)) {
      rentedBooks.remove(book);
      book.returnBook();
      print("Book '${book.gettitle}' returned successfully.");
    } else {
      print("Book '${book.gettitle}' is not rented by this user.");
    }
  }
}
