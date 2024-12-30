import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../../home/domain/entities/book_entiti.dart';

// Класс Rental (Аренда)
class Rental {
  final String? id; // ID аренды
  final Book book; // Арендуемая книга
  final String userId; // ID пользователя
  final DateTime rentalDate; // Дата начала аренды
  final DateTime dueDate; // Дата окончания аренды
  DateTime? returnDate; // Дата возврата книги

  // Конструктор
  Rental({
    this.id,
    required this.book,
    required this.userId,
    required this.rentalDate,
    required this.dueDate,
    this.returnDate,
  });

  // Метод для проверки доступности книги
  bool isBookAvailable() {
    return book.isAvailable && book.copyCount > 0;
  }

  // Метод для создания аренды
  static Future<Rental?> createRental({
    required Book book,
    required String userId,
    required int rentalPeriodDays,
  }) async {
    if (!book.isAvailable) {
      print("Book '${book.gettitle}' is not available for rental.");
      return null;
    }

    // Уменьшаем количество доступных копий книги
    book.rentBook();

    // Создаем объект Rental
    final rental = Rental(
      book: book,
      userId: userId,
      rentalDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: rentalPeriodDays)),
    );

    // Сохраняем аренду в Firestore
    try {
      final doc = await FirebaseFirestore.instance.collection('rentals').add({
        'bookId': book.id,
        'userId': userId,
        'rentalDate': rental.rentalDate.toIso8601String(),
        'dueDate': rental.dueDate.toIso8601String(),
        'returnDate': null,
      });

      return rental.copyWith(id: doc.id);
    } catch (e) {
      print("Ошибка при создании аренды: $e");
      return null;
    }
  }

  // Метод для возврата книги
  Future<void> returnBook() async {
    if (returnDate != null) {
      print("The book '${book.gettitle}' has already been returned.");
      return;
    }

    // Обновляем дату возврата
    returnDate = DateTime.now();

    // Увеличиваем количество копий книги
    book.returnBook();

    // Обновляем аренду в Firestore
    try {
      await FirebaseFirestore.instance
          .collection('rentals')
          .doc(id)
          .update({'returnDate': returnDate!.toIso8601String()});
    } catch (e) {
      print("Ошибка при обновлении аренды: $e");
    }
  }

  // Метод для копирования Rental с изменением параметров
  Rental copyWith({
    String? id,
    Book? book,
    String? userId,
    DateTime? rentalDate,
    DateTime? dueDate,
    DateTime? returnDate,
  }) {
    return Rental(
      id: id ?? this.id,
      book: book ?? this.book,
      userId: userId ?? this.userId,
      rentalDate: rentalDate ?? this.rentalDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
    );
  }
}
