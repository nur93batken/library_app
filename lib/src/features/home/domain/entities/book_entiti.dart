import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id; // Firestore документтин ID
  String _title;
  String _author;
  String _date;
  String _genres;
  int _copyCount;
  bool _isAvailable;

  // Конструктор
  Book({
    this.id,
    required String title,
    required String author,
    required String date,
    required String genres,
    required int copyCount,
    required bool isAvailable,
  })  : _title = title,
        _author = author,
        _date = date,
        _genres = genres,
        _copyCount = copyCount,
        _isAvailable = isAvailable;

  // Геттерлер
  String get gettitle => _title;
  String get author => _author;
  String get date => _date;
  String get genres => _genres;
  int get copyCount => _copyCount;
  bool get isAvailable => _isAvailable;

  // Сеттерлер
  set copyCount(int count) {
    _copyCount = count;
    _isAvailable = _copyCount > 0;
  }

  set title(String title) {
    _title = title;
  }

  set author(String author) {
    _author = author;
  }

  set date(String date) {
    _date = date;
  }

  set genres(String genres) {
    _genres = genres;
  }

  set isAvailable(bool status) {
    _isAvailable = status;
  }

  // Метод
  void updateStatus(bool isRented) {
    if (isRented && _copyCount > 0) {
      _copyCount--;
    } else if (!isRented) {
      _copyCount++;
    }
    _isAvailable = _copyCount > 0;
  }

  // Метод: Китепти алып келүү
  void rentBook() {
    if (_copyCount > 0) {
      _copyCount--;
      updateStatus(true);
    } else {
      print("Book '$gettitle' is not available.");
    }
  }

  // Метод: Китепти кайтаруу
  void returnBook() {
    _copyCount++;
    updateStatus(false);
  }

  // Метод copyWith
  Book copyWith({
    String? id,
    String? title,
    String? author,
    List<String>? genres,
    int? copyCount,
    bool? isAvailable,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.gettitle,
      author: author ?? this.author,
      copyCount: copyCount ?? this.copyCount,
      isAvailable: isAvailable ?? this.isAvailable,
      date: '',
      genres: '',
    );
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()
        as Map<String, dynamic>; // Преобразуем данные документа в карту
    return Book(
      id: doc.id,
      title: data['title'] ?? '', // Если нет title, используем пустую строку
      author: data['author'] ?? '', // Если нет author, используем пустую строку
      date: data['date'] ?? '', // Если нет date, используем пустую строку
      genres: data['genres'] ?? '', // Если нет genres, используем пустую строку
      copyCount: (data['copyCount'] is int)
          ? data['copyCount'] as int
          : 0, // Если copyCount не int, используем 0
      isAvailable: (data['isAvailable'] is bool)
          ? data['isAvailable'] as bool
          : false, // Если isAvailable не bool, используем false
    );
  }

  // Book объектин Firestore'го сактоого даярдоо
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': gettitle,
      'author': author,
      'date': date,
      'genres': genres,
      'copyCount': copyCount,
      'isAvailable': isAvailable,
    };
  }

  // Метод для преобразования данных из карты
  factory Book.fromJson(Map<String, dynamic> data) {
    return Book(
      id: data['id'] ?? '', // Если id нет, используем пустую строку
      title: data['title'] ?? '', // Если title нет, используем пустую строку
      author: data['author'] ?? '', // Если author нет, используем пустую строку
      date: data['date'] ?? '', // Если date нет, используем пустую строку
      genres: data['genres'] ?? '', // Если genres нет, используем пустую строку
      copyCount: data['copyCount'] ?? 0, // Если copyCount нет, используем 0
      isAvailable: data['isAvailable'] ??
          false, // Если isAvailable нет, используем false
    );
  }
}
