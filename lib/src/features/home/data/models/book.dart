class Book {
  String _title;
  String _author;
  String _date;
  String _genres;
  int _copyCount;
  bool _isAvailable;

  // Конструктор
  Book({
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

  // Геттер
  String get gettitle => _title;
  String get author => _author;
  String get date => _date;
  String get genres => _genres;
  int get copyCount => _copyCount;
  bool get isAvailable => _isAvailable;

  // Сеттер
  set copyCount(int count) {
    _copyCount = count;
    _isAvailable = _copyCount > 0;
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
}
