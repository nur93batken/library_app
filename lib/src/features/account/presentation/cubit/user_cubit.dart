import 'package:bloc/bloc.dart';
import 'package:my_books/src/features/account/presentation/cubit/user_state.dart';
import '../../../home/domain/entities/entities.dart';
import '../../domain/repositories/user_reposiroty.dart';

// Cubit для управления состоянием
class BookCubit extends Cubit<UserState> {
  final BookRepository bookRepository;
  List<Book> rentedBooks = [];

  BookCubit(this.bookRepository) : super(BookInitialState());

  // Метод аренды книги
  Future<void> rentBook(Book book) async {
    try {
      await bookRepository.rentBook(book);
      rentedBooks.add(book);
      emit(BookRentedState(rentedBooks));
    } catch (e) {
      print('Error renting book: $e');
    }
  }

  // Метод возврата книги
  Future<void> returnBook(Book book) async {
    try {
      await bookRepository.returnBook(book);
      rentedBooks.remove(book);
      emit(BookRentedState(rentedBooks));
    } catch (e) {
      print('Error returning book: $e');
    }
  }

  // Получение доступных книг
  Future<void> fetchBooks() async {
    try {
      final books = await bookRepository.getAvailableBooks();
      emit(BookRentedState(books));
    } catch (e) {
      print('Error fetching books: $e');
    }
  }
}
