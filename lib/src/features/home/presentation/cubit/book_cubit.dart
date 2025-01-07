import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositoryes.dart';

class BookCubit extends Cubit<List<Book>> {
  BookCubit({required this.bookRepository}) : super([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Китептерди жүктөө
  final BookRepository bookRepository;
  List<Book> _allBooks = [];

  Future<void> loadBooks() async {
    try {
      _allBooks = (await bookRepository.fetchBooks());
      emit(_allBooks);
    } catch (e) {
      emit([]); // Emit empty list on error
    }
  }

  void filterBooks(String genre) {
    if (genre == 'Все') {
      emit([..._allBooks]); // Показываем все книги
    } else {
      emit(_allBooks.where((book) => book.genres.contains(genre)).toList());
    }
  }

  // Китеп кошуу
  Future<void> addBook(Book book) async {
    try {
      await _firestore.collection('books').add(book.toFirestore());
      await loadBooks();
    } catch (e) {
      print('Ошибка при добавлении книги: $e');
    }
  }

  // Китепти ижарага алуу
  Future<void> rentBook(Book book, int) async {
    if (book.id == null) return; // ID текшерүү
    try {
      if (book.copyCount > 0) {
        await _firestore.collection('books').doc(book.id).update({
          'copyCount': book.copyCount - 1,
          'isAvailable': (book.copyCount - 1) > 0,
        });
        loadBooks();
        filterBooks('Все');
      } else {
        print('Книга больше недоступна.');
      }
    } catch (e) {
      print('Ошибка при аренде книги: $e');
    }
  }

  // Китепти кайтаруу
  Future<void> returnBook(Book book) async {
    if (book.id == null) return;

    try {
      final doc = await _firestore.collection('books').doc(book.id).get();
      if (!doc.exists) {
        print('Книга не найдена');
        return;
      }

      final data = doc.data();
      final currentCopyCount = data?['copyCount'] ?? 0;

      // Обновляем книгу
      await _firestore.collection('books').doc(book.id).update({
        'copyCount': currentCopyCount + 1,
        'isAvailable': true,
      });

      // Перезагружаем книги и фильтруем
      await loadBooks();
      filterBooks('Все');
    } catch (e) {
      print('Ошибка при возврате книги: $e');
    }
  }
}
