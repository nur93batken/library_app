import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/models.dart';

class BookCubit extends Cubit<List<Book>> {
  BookCubit() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Китептерди жүктөө
  Future<void> loadBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      final books = snapshot.docs.map((doc) {
        return Book.fromFirestore(doc.data(), doc.id);
      }).toList();
      emit(books);
    } catch (e) {
      print('Ошибка при загрузке книг: $e');
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
  Future<void> rentBook(Book book) async {
    if (book.id == null) return; // ID текшерүү
    try {
      if (book.copyCount > 0) {
        await _firestore.collection('books').doc(book.id).update({
          'copyCount': book.copyCount - 1,
          'isAvailable': (book.copyCount - 1) > 0,
        });
        await loadBooks();
      } else {
        print('Книга больше недоступна.');
      }
    } catch (e) {
      print('Ошибка при аренде книги: $e');
    }
  }

  // Китепти кайтаруу
  Future<void> returnBook(Book book) async {
    if (book.id == null) return; // ID текшерүү
    try {
      await _firestore.collection('books').doc(book.id).update({
        'copyCount': book.copyCount + 1,
        'isAvailable': true,
      });
      await loadBooks();
    } catch (e) {
      print('Ошибка при возврате книги: $e');
    }
  }
}
