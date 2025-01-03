import '../../../home/domain/entities/entities.dart';
import 'entities.dart';

class Member extends User {
  Member(
      {required String name,
      required String id,
      List<Book> rentedBooks = const []})
      : super(name: name, id: id, rentedBooks: rentedBooks);

  // Метод для возврата книги
  void returnBook(Book book) {
    rentedBooks.remove(book);
  }
}
