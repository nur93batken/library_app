import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_books/src/features/home/domain/entities/entities.dart';

class BookRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения доступных книг
  Future<List<Book>> getAvailableBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs.where((doc) => doc['copyCount'] > 0).map((doc) {
        return Book(
          id: doc.id,
          title: doc['title'] ?? '',
          author: doc['author'] ?? '',
          date: doc['date'] ?? '',
          genres: doc['genres'] ?? '',
          copyCount: doc['copyCount'] ?? '',
          isAvailable: doc['isAvailable'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching books: $e");
    }
  }

  // Метод для аренды книги
  Future<void> rentBook(Book book) async {
    try {
      final docRef = _firestore.collection('books').doc(book.id.toString());
      final doc = await docRef.get();
      if (doc.exists && doc['copyCount'] > 0) {
        await docRef.update({
          'copyCount': doc['copyCount'] - 1,
        });
      }
    } catch (e) {
      throw Exception("Error renting book: $e");
    }
  }

  // Метод для возврата книги
  Future<void> returnBook(Book book) async {
    try {
      final docRef = _firestore.collection('books').doc(book.id.toString());
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({
          'copyCount': doc['copyCount'] + 1,
        });
      }
    } catch (e) {
      throw Exception("Error returning book: $e");
    }
  }
}
