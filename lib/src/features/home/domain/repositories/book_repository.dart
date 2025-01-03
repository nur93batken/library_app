// File: book_repository.dart (Repository)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_books/src/features/authentication/models/user_model.dart';
import '../entities/entities.dart';

abstract class BookRepository {
  Future<List<Book>> fetchBooks();
}

class FirebaseBookRepository implements BookRepository {
  final FirebaseFirestore _firestore;

  FirebaseBookRepository(this._firestore);

  @override
  Future<List<Book>> fetchBooks() async {
    try {
      final querySnapshot = await _firestore.collection('books').get();
      print(
          'Books fetched: ${querySnapshot.docs.length}'); // Выводим количество полученных книг
      return querySnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return []; // Возвращаем пустой список в случае ошибки
    }
  }

  Future<void> updateUserBooks(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'rentedBooks':
            user.rentedBooks.map((book) => book.toFirestore()).toList(),
      });
      print("User data updated successfully");
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  // Метод для обновления книги в Firestore
  Future<void> updateBook(Book book) async {
    try {
      // Обновляем количество копий книги в Firestore
      await _firestore.collection('books').doc(book.id).update({
        'copyCount': book.copyCount,
      });
    } catch (e) {
      print("Error updating book: $e");
    }
  }

  Future<String> getBookTitle(String bookId) async {
    try {
      final doc = await _firestore.collection('books').doc(bookId).get();
      if (doc.exists) {
        return doc.data()?['title'] ?? 'Без названия';
      } else {
        return 'Книга не найдена';
      }
    } catch (e) {
      print("Ошибка при получении названия книги: $e");
      return 'Ошибка загрузки названия';
    }
  }

  Future<Book> getBookById(String bookId) async {
    final doc = await _firestore.collection('books').doc(bookId).get();
    if (doc.exists) {
      return Book.fromDocument(doc);
    } else {
      throw Exception('Book not found');
    }
  }
}
