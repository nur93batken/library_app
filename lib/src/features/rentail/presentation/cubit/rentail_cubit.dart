import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/repositories/repositoryes.dart';
import '../../domain/entities/rentail.dart';
import '../../domain/repositories/rental_repository.dart';
import 'rentail_state.dart';

class RentalCubit extends Cubit<RentalState> {
  final RentalRepository rentalRepository;
  final FirebaseBookRepository bookRepository;

  RentalCubit(this.rentalRepository, this.bookRepository)
      : super(RentalInitial());

  /// Создание аренды
  Future<void> createRental({
    required String bookId,
    required String userId,
    required String userName,
    required String bookTitle,
    required int rentalPeriodDays,
  }) async {
    emit(RentalLoading());

    try {
      final rental = await rentalRepository.createRental(
        bookId: bookId,
        bookTitle: bookTitle,
        userId: userId,
        userName: userName,
        rentalPeriodDays: rentalPeriodDays,
      );

      if (rental != null) {
        emit(RentalSuccess(rental: rental));
      } else {
        emit(RentalError(message: "Failed to create rental."));
      }
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }

  /// Возврат книги
  Future<void> returnBook(Rental rental) async {
    emit(RentalLoading()); // Состояние загрузки

    try {
      // Удаляем аренду из Firebase через репозиторий
      await rentalRepository
          .deleteRentalById(rental.id.toString()); // Удаляем по ID аренды

      // Обновляем список аренд
      final rentals = await rentalRepository.getRentalsByUserId(rental.userId);
      emit(RentalListLoaded(rentals: rentals));
    } catch (e) {
      emit(RentalError(message: e.toString())); // Ошибка
    }
  }

  /// Получение всех аренд
  Future<void> fetchRentals() async {
    emit(RentalLoading());
    try {
      final rentals = await rentalRepository.fetchRentals();
      emit(RentalListLoaded(rentals: rentals));
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }

  /// Получение аренд по ID книги
  Future<void> fetchRentalsByBookId(String bookId) async {
    emit(RentalLoading());
    try {
      final rentals = await rentalRepository.getRentalsByBookId(bookId);
      emit(RentalListLoaded(rentals: rentals));
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }

  /// Получение аренд по ID пользователя
  Future<void> fetchRentalsByUserId(String userId) async {
    emit(RentalLoading());
    try {
      final rentals = await rentalRepository.getRentalsByUserId(userId);

      // Добавляем название книги для каждой аренды
      final enrichedRentals = await Future.wait(
        rentals.map((rental) async {
          final bookTitle = await bookRepository.getBookTitle(rental.bookId);
          return rental.copyWith(bookTitle: bookTitle);
        }),
      );

      emit(RentalListLoaded(rentals: enrichedRentals));
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }
}
