import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/book.dart';
import '../cubit/book_cubit.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.gettitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Автор: ${book.author}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Жанр: ${book.genres}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Копий: ${book.copyCount}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<BookCubit>().rentBook(book);
                Navigator.pop(context);
              },
              child: const Text('Ижарага алуу'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<BookCubit>().returnBook(book);
                Navigator.pop(context);
              },
              child: const Text('Кайтаруу'),
            ),
          ],
        ),
      ),
    );
  }
}
