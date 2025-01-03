import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../entities/rentail.dart';

class RentalRepository {
  final FirebaseFirestore firestore;

  RentalRepository(this.firestore);

  Future<Rental?> createRental({
    required String bookId,
    required String userId,
    required String userName,
    required int rentalPeriodDays,
  }) async {
    try {
      // Уменьшаем количество доступных копий книги

      final rental = Rental(
        userName: userName,
        bookId: bookId,
        userId: userId,
        rentalDate: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: rentalPeriodDays)),
      );

      final doc = await firestore.collection('rentals').add({
        'bookId': bookId,
        'userId': userId,
        'rentalDate': rental.rentalDate.toIso8601String(),
        'dueDate': rental.dueDate!.toIso8601String(),
        'returnDate': null,
      });

      return rental.copyWith(id: doc.id);
    } catch (e) {
      debugPrint("Error creating rental: $e");
      return null;
    }
  }

  Future<void> deleteRental(String bookId, String userId) async {
    try {
      // Находим документ аренды по bookId
      final querySnapshot = await firestore
          .collection('rentals') // Имя коллекции с арендами
          .where('bookId', isEqualTo: bookId)
          .get();

      // Удаляем все найденные документы
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete rental: $e');
    }
  }

  Future<void> returnBook(Rental rental) async {
    if (rental.returnDate != null) {
      debugPrint("Book '${rental.bookId}' has already been returned.");
      return;
    }

    try {
      rental.returnDate = DateTime.now();

      await firestore.collection('rentals').doc(rental.id).update({
        'returnDate': rental.returnDate!.toIso8601String(),
      });
    } catch (e) {
      debugPrint("Error updating rental: $e");
    }
  }

  Future<List<Rental>> fetchRentals() async {
    try {
      final snapshot = await firestore.collection('rentals').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Rental(
          id: doc.id,
          bookId: data['bookId'], // Имплементация метода `fromFirestore`
          userId: data['userId'],
          userName: data['userName'],
          rentalDate: DateTime.parse(data['rentalDate']),
          dueDate: DateTime.parse(data['dueDate']),
          returnDate: data['returnDate'] != null
              ? DateTime.parse(data['returnDate'])
              : null,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error fetching rentals: $e");
      return [];
    }
  }

  // Получение всех аренд по bookId
  Future<List<Rental>> getRentalsByBookId(String bookId) async {
    try {
      final querySnapshot = await firestore
          .collection('rentals')
          .where('bookId', isEqualTo: bookId)
          .get();

      List<Rental> rentals = [];
      for (var doc in querySnapshot.docs) {
        final rentalData = doc.data();
        final userId = rentalData['userId'];

        // Загружаем данные пользователя из коллекции 'users'
        final userDoc = await firestore.collection('users').doc(userId).get();
        final userName = userDoc.data()?['email'] ?? 'Неизвестный пользователь';

        // Создаём объект Rental с именем пользователя
        rentals.add(Rental.fromMap({...rentalData, 'userName': userName}));
      }

      return rentals;
    } catch (e) {
      throw Exception('Failed to get rentals by bookId: $e');
    }
  }
}
