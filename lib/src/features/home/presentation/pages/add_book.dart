import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/book.dart';
import '../cubit/book_cubit.dart';

class AddBookScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить книгу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название книги'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Автор'),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(
                    labelText: 'Жанр (например: Программирование)'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Год издания'),
                keyboardType: TextInputType.number, // Ожидается ввод числа
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final author = authorController.text;
                  final genre = genreController.text;
                  final year = yearController.text;

                  if (title.isNotEmpty &&
                      author.isNotEmpty &&
                      genre.isNotEmpty &&
                      year.isNotEmpty) {
                    final newBook = Book(
                      title: title,
                      author: author,
                      genres: genre, // Добавляем жанр в виде списка
                      copyCount: 1,
                      isAvailable: true,
                      date: year, // Используем год издания
                    );
                    context.read<BookCubit>().addBook(newBook);
                    Navigator.pop(
                        context); // Возвращаемся назад после добавления
                  } else {
                    // Показываем сообщение, если поля не заполнены
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Заполните все поля!')),
                    );
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
