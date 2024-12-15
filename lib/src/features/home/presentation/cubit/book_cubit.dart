import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';

class BookCubit extends Cubit<List<Book>> {
  BookCubit() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Загрузка книг
  Future<void> loadBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      final books = snapshot.docs.map((doc) {
        final data = doc.data();
        return Book(
          title: data['title'],
          author: data['author'],
          genres: data['genres'],
          copyCount: data['copyCount'],
          isAvailable: data['isAvailable'],
          date: data['date'],
        );
      }).toList();
      emit(books);
    } catch (e) {
      print('Ошибка при загрузке книг: $e');
    }
  }

  // Добавление книги
  Future<void> addBook(Book book) async {
    try {
      final newBookRef = _firestore.collection('books').doc();
      await newBookRef.set({
        'title': book.gettitle,
        'author': book.author,
        'genres': book.genres,
        'copyCount': book.copyCount,
        'isAvailable': book.isAvailable,
        'date': book.date,
      });
      loadBooks(); // Обновляем список книг
    } catch (e) {
      print('Ошибка при добавлении книги: $e');
    }
  }

  // Аренда книги
  Future<void> rentBook(Book book) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('title', isEqualTo: book.gettitle)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        if (data['copyCount'] > 0) {
          // Уменьшаем количество копий
          await _firestore.collection('books').doc(doc.id).update({
            'copyCount': data['copyCount'] - 1,
            'isAvailable': (data['copyCount'] - 1) > 0,
          });
          loadBooks(); // Обновляем список книг
        } else {
          print('Книга больше недоступна.');
        }
      } else {
        print('Книга не найдена в базе данных.');
      }
    } catch (e) {
      print('Ошибка при аренде книги: $e');
    }
  }

  // Возврат книги
  Future<void> returnBook(Book book) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('title', isEqualTo: book.gettitle)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        // Увеличиваем количество копий
        await _firestore.collection('books').doc(doc.id).update({
          'copyCount': data['copyCount'] + 1,
          'isAvailable': true,
        });
        loadBooks(); // Обновляем список книг
      } else {
        print('Книга не найдена в базе данных.');
      }
    } catch (e) {
      print('Ошибка при возврате книги: $e');
    }
  }
}
