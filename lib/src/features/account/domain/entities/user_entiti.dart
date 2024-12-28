import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../home/domain/entities/entities.dart';

class User {
  String name;
  String id;
  List<Book> rentedBooks = [];

  User({required this.name, required this.id, this.rentedBooks = const []});

  // Метод для добавления книги в арендованные
  void rentBook(Book book) {
    rentedBooks.add(book);
  }

  // Преобразование пользователя в Map для сохранения в Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'rentedBooks': rentedBooks.map((book) => book.toFirestore()).toList(),
    };
  }

  // Извлечение пользователя из Firestore (для восстановления объекта User)
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      name: data['name'],
      id: data['id'],
      rentedBooks: (data['rentedBooks'] as List)
          .map((bookData) => Book.fromFirestore(bookData))
          .toList(),
    );
  }
}
