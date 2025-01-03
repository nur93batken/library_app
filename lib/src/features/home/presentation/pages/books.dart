import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account/domain/repositories/repositories.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
import '../../../rentail/domain/repositories/rental_repository.dart';
import '../../../rentail/presentation/cubit/rentail_cubit.dart';
import '../../../rentail/presentation/cubit/rentail_state.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositoryes.dart';
import '../cubit/book_cubit.dart';
import '../widgets/widgets.dart';

class BookScreen extends StatefulWidget {
  @override
  _GenreFilterExampleState createState() => _GenreFilterExampleState();
}

class _GenreFilterExampleState extends State<BookScreen> {
  String selectedGenre = 'Все';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('Error: User is not logged in');
      return null;
    }
    return user.uid;
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
            body: BlocBuilder<BookCubit, List<Book>>(
              builder: (context, books) {
                return Column(
                  children: [
                    GenreFilterWidget(
                      selectedGenre: selectedGenre,
                      onGenreSelected: (genre) {
                        setState(() {
                          selectedGenre = genre;
                        });
                        context.read<BookCubit>().filterBooks(genre);
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const CircularProgressIndicator(); // Показываем индикатор загрузки
                        } else if (state is UserLoaded) {
                          return Expanded(
                            child: BookList(
                              books: books,
                              onBookSelected: (book) {
                                Book my_book = Book(
                                    id: book.id,
                                    author: book.author,
                                    date: book.date,
                                    genres: book.genres,
                                    copyCount: 2,
                                    isAvailable: true,
                                    title: book.gettitle);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  context: context,
                                  builder: (_) => BlocProvider(
                                    create: (context) => RentalCubit(
                                        RentalRepository(
                                            FirebaseFirestore.instance)),
                                    child: RentBookModal(
                                      book: book,
                                      my_book: my_book,
                                      initialDays: 5,
                                      onRent: (days) {
                                        context
                                            .read<RentalCubit>()
                                            .fetchRentalsByBookId(
                                                book.id.toString());
                                        context
                                            .read<BookCubit>()
                                            .rentBook(book, days);

                                        context
                                            .read<UserCubit>()
                                            .rentBook(my_book);
                                        final userId = getCurrentUserId();
                                        if (userId != null) {
                                          context
                                              .read<RentalCubit>()
                                              .createRental(
                                                bookId: book.id.toString(),
                                                userId: userId,
                                                userName: '',
                                                rentalPeriodDays: days,
                                              );
                                        } else {
                                          debugPrint(
                                              'Error: Cannot create rental, user ID is null.');
                                        }
                                      },
                                      bookId: book.id.toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is UserError) {
                          return Text(
                              'Ошибка загрузки пользователя: ${state.message}');
                        }
                        return const Text('Инициализация...');
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
