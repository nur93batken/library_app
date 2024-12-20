import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositoryes.dart';
import '../cubit/book_cubit.dart';
import '../widgets/widgets.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookCubit(
          bookRepository: FirebaseBookRepository(FirebaseFirestore.instance))
        ..loadBooks(),
      child: Scaffold(
        body: BlocBuilder<BookCubit, List<Book>>(
          builder: (context, books) {
            return Column(
              children: [
                GenreFilterWidget(
                  selectedGenre: 'Все',
                  onGenreSelected: (genre) {
                    context.read<BookCubit>().filterBooks(genre);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BookList(
                    books: books,
                    onBookSelected: (book) {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        context: context,
                        builder: (_) => RentBookModal(
                          book: book,
                          initialDays: 5,
                          onRent: (days) {
                            context.read<BookCubit>().rentBook(book, days);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
