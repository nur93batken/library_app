import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';

class BookCubit extends Cubit<List<Book>> {
  BookCubit() : super([]);

  // Китеп кошуу
  void addBook(Book book) {
    final updatedBooks = List<Book>.from(state);
    updatedBooks.add(book);
    emit(updatedBooks);
  }

  // Китепти ижарага алуу
  void rentBook(Book book) {
    final updatedBooks = state.map((b) {
      if (b.gettitle == book.gettitle && b.copyCount > 0) {
        return Book(
          title: b.gettitle,
          author: b.author,
          genres: b.genres,
          copyCount: b.copyCount - 1,
          isAvailable: b.copyCount > 0,
          date: '', // Учурдагы датаны белгилөө
        );
      }
      return b;
    }).toList();
    emit(updatedBooks);
  }

  // Китепти кайтаруу
  void returnBook(Book book) {
    final updatedBooks = state.map((b) {
      if (b.gettitle == book.gettitle) {
        return Book(
          title: b.gettitle,
          author: b.author,
          genres: b.genres,
          isAvailable: b.copyCount > 0,
          copyCount: b.copyCount + 1,
          date: '', // Кайтарганда датаны бош койдук
        );
      }
      return b;
    }).toList();
    emit(updatedBooks);
  }
}
