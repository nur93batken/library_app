import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/src/features/account/domain/repositories/repositories.dart';
import 'package:my_books/src/features/home/presentation/cubit/book_cubit.dart';
import 'package:my_books/src/features/rentail/domain/entities/rentail.dart';
import 'package:my_books/src/features/rentail/presentation/cubit/rentail_cubit.dart';

import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../../rentail/domain/repositories/rental_repository.dart';
import '../../../rentail/presentation/cubit/rentail_state.dart';
import '../../domain/repositories/book_repository.dart';

class RentedBooksScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RentalCubit>(
          create: (context) => RentalCubit(
            RentalRepository(FirebaseFirestore.instance),
          )..fetchRentals(),
        ),
        BlocProvider<BookCubit>(
          create: (context) => BookCubit(
              bookRepository:
                  FirebaseBookRepository(FirebaseFirestore.instance))
            ..loadBooks(),
        ),
        BlocProvider<UserCubit>(
          create: (context) =>
              UserCubit(BookUserRepository())..loadUser(getCurrentUserId()!),
        ),
      ],
      child: BlocBuilder<RentalCubit, RentalState>(
        builder: (context, state) {
          return Scaffold(
            body: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                // Проверяем состояние
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  // Получаем арендованные книги из состояния
                  final rentedBooks = state.user.rentedBooks;

                  // Если нет арендованных книг
                  if (rentedBooks.isEmpty) {
                    return const Center(
                        child: Text('У вас нет арендованных книг.'));
                  }

                  // Отображаем список арендованных книг
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: rentedBooks.length,
                      itemBuilder: (context, index) {
                        final book = rentedBooks[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(book.gettitle),
                              subtitle: Text(book.author),
                            ),
                            TextButton(
                                onPressed: () {
                                  context.read<BookCubit>().returnBook(book);
                                  context.read<UserCubit>().returnBook(book);
                                  final userId = getCurrentUserId();
                                  if (userId != null) {
                                    final rental = Rental(
                                      bookId: book.id.toString(),
                                      userId: userId,
                                      userName: '',
                                      rentalDate: DateTime.now(),
                                      returnDate: DateTime.now(),
                                      dueDate: null,
                                    );
                                    context.read<RentalCubit>().returnBook(
                                        rental, book.id.toString(), userId);
                                  } else {
                                    debugPrint(
                                        'Error: Cannot create rental, user ID is null.');
                                  }
                                },
                                child: const Text('Вернуть книгу')),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  );
                } else if (state is UserError) {
                  return Center(child: Text('Ошибка: ${state.message}'));
                }

                return const Center(child: Text('Неизвестное состояние.'));
              },
            ),
          );
        },
      ),
    );
  }
}
