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

  // Firestore'дон келген маалыматтарды Book объектисине айландыруу
  factory Book.fromFirestore(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'],
      author: data['author'],
      date: data['date'],
      genres: data['genres'],
      copyCount: data['copyCount'],
      isAvailable: data['isAvailable'],
    );
  }

  // Book объектин Firestore'го сактоого даярдоо
  Map<String, dynamic> toFirestore() {
    return {
      'title': gettitle,
      'author': author,
      'date': date,
      'genres': genres,
      'copyCount': copyCount,
      'isAvailable': isAvailable,
    };
  }
}
