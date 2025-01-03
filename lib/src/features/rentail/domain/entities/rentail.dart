import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../../home/domain/entities/book_entiti.dart';

// Класс Rental (Аренда)
class Rental {
  final String? id; // ID аренды
  final String bookId; // Арендуемая книга
  final String userId; // ID пользователя
  final DateTime rentalDate; // Дата начала аренды
  DateTime? dueDate; // Дата окончания аренды
  DateTime? returnDate; // Дата возврата книги
  final String userName;

  // Конструктор
  Rental({
    this.id,
    required this.bookId,
    required this.userName,
    required this.userId,
    required this.rentalDate,
    this.dueDate,
    this.returnDate,
  });

  // Метод для создания аренды
  static Future<Rental?> createRental({
    required String bookId,
    required String userId,
    required String userName,
    required int rentalPeriodDays,
  }) async {
    // Создаем объект Rental
    final rental = Rental(
      userName: userName,
      bookId: bookId,
      userId: userId,
      rentalDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: rentalPeriodDays)),
    );

    // Сохраняем аренду в Firestore
    try {
      final doc = await FirebaseFirestore.instance.collection('rentals').add({
        'bookId': bookId,
        'userId': userId,
        'rentalDate': rental.rentalDate.toIso8601String(),
        'dueDate': rental.dueDate!.toIso8601String(),
        'returnDate': null,
      });

      return rental.copyWith(id: doc.id);
    } catch (e) {
      print("Ошибка при создании аренды: $e");
      return null;
    }
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    try {
      return Rental(
        id: map['id'] ?? '',
        bookId: map['bookId'] ?? '',
        userId: map['userId'] ?? '',
        userName: map['userName'],
        rentalDate: map['rentalDate'] != null
            ? DateTime.tryParse(map['rentalDate']) ?? DateTime.now()
            : DateTime.now(),
        returnDate: map['returnDate'] != null
            ? DateTime.tryParse(map['returnDate'])
            : null,
      );
    } catch (e) {
      throw Exception('Error parsing Rental from map: $e');
    }
  }

  // Преобразование объекта Rental в Map для сохранения в Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'userId': userId,
      'userNmae': userName,
      'rentalDate': rentalDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
    };
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
      bookId: this.bookId,
      userName: this.userName,
      userId: userId ?? this.userId,
      rentalDate: rentalDate ?? this.rentalDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
    );
  }
}
