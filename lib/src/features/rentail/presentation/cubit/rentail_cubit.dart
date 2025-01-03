import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/rentail.dart';
import '../../domain/repositories/rental_repository.dart';
import 'rentail_state.dart';

class RentalCubit extends Cubit<RentalState> {
  final RentalRepository rentalRepository;

  RentalCubit(this.rentalRepository) : super(RentalInitial());

  Future<void> createRental({
    required String bookId,
    required String userId,
    required String userName,
    required int rentalPeriodDays,
  }) async {
    emit(RentalLoading());

    try {
      final rental = await rentalRepository.createRental(
        bookId: bookId,
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

  Future<void> returnBook(Rental rental, String bookId, String userId) async {
    emit(RentalLoading()); // Состояние загрузки

    try {
      // Удаляем аренду из Firebase через репозиторий
      await rentalRepository.deleteRental(bookId, userId);

      emit(RentalSuccess(rental: rental)); // Успешное состояние
    } catch (e) {
      emit(RentalError(message: e.toString())); // Ошибка
    }
  }

  Future<void> fetchRentals() async {
    emit(RentalLoading());

    try {
      final rentals = await rentalRepository.fetchRentals();
      emit(RentalListLoaded(rentals: rentals));
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }

  Future<void> fetchRentalsByBookId(String bookId) async {
    emit(RentalLoading());

    try {
      final rentals = await rentalRepository.getRentalsByBookId(bookId);
      emit(RentalListLoaded(rentals: rentals));
    } catch (e) {
      emit(RentalError(message: e.toString()));
    }
  }
}
