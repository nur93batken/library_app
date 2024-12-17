import 'package:firebase_auth/firebase_auth.dart';

import 'models.dart';

class Rental {
  final Book book;
  final User user;
  final DateTime rentalDate;
  final DateTime? returnDate;
  final Duration rentalPeriod;

  Rental({
    required this.book,
    required this.user,
    required this.rentalPeriod,
    required this.rentalDate,
    this.returnDate,
  });

  // Китептин жеткиликтүүлүгүн текшерүү
  bool isBookAvailable() {
    return book.isAvailable;
  }

  // Ижара түзүү
  static Rental? createRental({
    required Book book,
    required User user,
    required Duration rentalPeriod,
  }) {
    if (book.isAvailable) {
      book.rentBook(); // Китептин нускасын азайтуу
      return Rental(
        book: book,
        user: user,
        rentalPeriod: rentalPeriod,
        rentalDate: DateTime.now(),
      );
    } else {
      print("Китеп '${book.gettitle}' жеткиликтүү эмес.");
      return null;
    }
  }

  // Китепти кайтаруу
  void returnRental() {
    book.returnBook(); // Китептин нускасын көбөйтүү
    print("Китеп '${book.gettitle}' ийгиликтүү кайтарылды.");
  }
}
