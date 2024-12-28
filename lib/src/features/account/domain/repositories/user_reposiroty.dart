import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_books/src/features/home/domain/entities/entities.dart';

import '../../../authentication/models/user_model.dart';

class BookUserRepository {
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

  // Сохранение данных пользователя в Firebase
  Future<void> saveUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.email,
        'id': user.uid,
        'rentedBooks':
            user.rentedBooks.map((book) => book.toFirestore()).toList(),
      });
    } catch (e) {
      throw Exception('Error saving user: $e');
    }
  }

  // Загрузка данных пользователя из Firebase
  Future<User?> loadUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id.toString()).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          email: data['email'],
          uid: data['uid'],
          rentedBooks: (data['rentedBooks'] as List)
              .map((bookData) => Book.fromFirestore(bookData))
              .toList(),
          password: data['password'],
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error loading user: $e');
    }
  }

  Future<User> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('Пользователь не найден');
    }
    return User.fromJson(doc.data()!);
  }

  Future<void> updateUserBooks(User user) async {
    try {
      print(
          'New rentedBooks: ${user.rentedBooks.map((book) => book.toFirestore()).toList()}');
      await _firestore.collection('users').doc(user.uid).update({
        'rentedBooks':
            user.rentedBooks.map((book) => book.toFirestore()).toList(),
        'isGroup': true
      });
      print('Firestore updated successfully.');
    } catch (e) {
      print('Error updating Firestore: $e');
      throw Exception('Error updating user books: $e');
    }
  }
}
