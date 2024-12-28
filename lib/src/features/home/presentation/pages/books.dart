import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../account/domain/repositories/repositories.dart';
import '../../../account/presentation/cubit/account_cubit.dart';
import '../../../account/presentation/cubit/account_state.dart';
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
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: Scaffold(
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
                      return CircularProgressIndicator(); // Показываем индикатор загрузки
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
                              builder: (_) => RentBookModal(
                                book: book,
                                my_book: my_book,
                                initialDays: 5,
                                onRent: (days) {
                                  context
                                      .read<BookCubit>()
                                      .rentBook(book, days);

                                  context.read<UserCubit>().rentBook(my_book);
                                },
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
      ),
    );
  }
}
