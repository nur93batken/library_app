// File: book_repository.dart (Repository)
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';

abstract class BookRepository {
  Future<List<Book>> fetchBooks();
}

class FirebaseBookRepository implements BookRepository {
  final FirebaseFirestore _firestore;

  FirebaseBookRepository(this._firestore);

  @override
  Future<List<Book>> fetchBooks() async {
    final querySnapshot = await _firestore.collection('books').get();
    return querySnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
  }
}
