import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import 'account_state.dart';

class UserCubit extends Cubit<UserState> {
  final BookUserRepository _repository;

  UserCubit(this._repository) : super(UserState());

  // Загрузка данных пользователя
  Future<void> loadUser(String userId) async {
    emit(UserLoading());
    try {
      final user =
          await _repository.getUserById(userId); // Загружаем пользователя
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Ошибка загрузки пользователя: $e'));
    }
  }

  // Аренда книги
  Future<void> rentBook(Book book) async {
    if (state is! UserLoaded) {
      print('Ошибка: пользователь не загружен');
      return;
    }

    final user = (state as UserLoaded).user;

    try {
      // Обновляем данные пользователя
      user.rentBook(book);

      // Обновляем данные в базе данных
      await _repository.updateUserBooks(user);

      // Обновляем состояние с новым пользователем
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Ошибка аренды книги: $e'));
    }
  }

  // Возврат книги
  Future<void> returnBook(Book book) async {
    if (state.user == null) return;
    final user = (state as UserLoaded).user;
    try {
      user.returnBook(book);
      await _repository.updateUserBooks(user);
      await loadUser(user.uid);
      print('Firestore updated successfully.');
      emit(UserLoaded(user));
    } catch (e) {
      print('Error updating Firestore: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
