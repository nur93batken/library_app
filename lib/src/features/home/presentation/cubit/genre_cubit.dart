import 'package:bloc/bloc.dart';
import '../../data/models/models.dart';

// Состояние фильтра
class GenreFilterState {
  final String selectedGenre;
  final List<Book> filteredBooks;

  GenreFilterState({required this.selectedGenre, required this.filteredBooks});
}

// Cubit для управления состоянием жанра
class GenreFilterCubit extends Cubit<GenreFilterState> {
  final List<Book> books;

  GenreFilterCubit({required this.books})
      : super(GenreFilterState(selectedGenre: 'Все', filteredBooks: books));

  // Метод для изменения жанра и применения фильтра
  void changeGenre(String genre) {
    final filteredBooks = _applyGenreFilter(genre);
    emit(GenreFilterState(selectedGenre: genre, filteredBooks: filteredBooks));
  }

  // Метод для фильтрации книг по жанру
  List<Book> _applyGenreFilter(String genre) {
    if (genre == 'Все') {
      return books;
    }
    return books.where((book) => book.genres.contains(genre)).toList();
  }
}
