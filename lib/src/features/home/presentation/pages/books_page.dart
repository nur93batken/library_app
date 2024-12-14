import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/src/features/home/data/models/book.dart';

import '../cubit/book_cubit.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  // Список книг
  final List<Book> books = [
    Book(
        title: 'Flutter Development',
        author: 'John Doe',
        date: '2021',
        genres: 'Программирование',
        copyCount: 5,
        isAvailable: true),
    Book(
        title: 'Dart Programming',
        author: 'Jane Smith',
        date: '2020',
        genres: 'Программирование',
        copyCount: 2,
        isAvailable: true),
    Book(
        title: 'Mobile App Design',
        author: 'Alice Johnson',
        date: '2019',
        genres: 'Дизайн',
        copyCount: 0,
        isAvailable: false),
    Book(
        title: 'State Management in Flutter',
        author: 'Chris Brown',
        date: '2023',
        genres: 'Программирование',
        copyCount: 4,
        isAvailable: true),
    Book(
        title: 'Firebase for Flutter',
        author: 'Emily Davis',
        date: '2022',
        genres: 'Программирование',
        copyCount: 3,
        isAvailable: true),
  ];

  // Список фильтрованных книг
  List<Book> filteredBooks = [];

  // Список жанров
  final List<String> genres = ['Все', 'Программирование', 'Дизайн'];

  // Переменная для выбранного жанра
  String selectedGenre = 'Все';

  double _currentDay = 5; // Начальное значение день

  // Изначально показываем все книги
  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty && selectedGenre == 'Все') {
        filteredBooks =
            books; // Если строка поиска и жанр пустые, показываем все книги
      } else {
        filteredBooks = books
            .where((book) =>
                (book.gettitle.toLowerCase().contains(query.toLowerCase()) ||
                    book.author.toLowerCase().contains(query.toLowerCase())) &&
                (selectedGenre == 'Все' || book.genres == selectedGenre))
            .toList(); // Фильтруем книги по названию, автору и жанру
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для поиска
            TextField(
              onChanged: _filterBooks, // Обработка ввода в поле
              decoration: InputDecoration(
                hintText: 'Введите запрос',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
            const SizedBox(
                height:
                    16), // Добавляем отступ между поисковым полем и списком жанров

            // Фильтр по жанрам
            SizedBox(
              height: 50, // Высота для горизонтального скролла
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGenre = genre;
                        _filterBooks(
                            ''); // Обновляем фильтрацию при изменении жанра
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: selectedGenre == genre
                            ? Colors.blue
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Center(
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: selectedGenre == genre
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
                height: 16), // Добавляем отступ между фильтром и списком книг

            // Список книг
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.gettitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Автор: ${book.author}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Жанр: ${book.genres}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'Год издания: ${book.date}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const Divider(
                            color: Colors.grey, // Цвет линии
                            thickness: 1, // Толщина линии
                            height: 16, // Пространство перед и после линии
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'В библиотеке: ${book.copyCount}шт.',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: book.isAvailable
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              IconButton(
                                icon: const Icon(Icons.star_border_outlined),
                                onPressed: () {
                                  // Обработка нажатия на кнопку "Информация"
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(book.gettitle),
                                      content: Text('Автор: ${book.author}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Закрыть'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // Обработка нажатия на кнопку "Информация"
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled:
                                        true, // Позволяет модальному окну занимать всю высоту
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (BuildContext context) {
                                      String title = book.gettitle;
                                      String author = book.author;
                                      double localDay =
                                          _currentDay; // Локальное состояние
                                      double localPrice = 146;
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setModalState) {
                                          return DraggableScrollableSheet(
                                            expand: false,
                                            initialChildSize:
                                                0.6, // Начальная высота (70% экрана)
                                            minChildSize:
                                                0.4, // Минимальная высота (40% экрана)
                                            maxChildSize:
                                                1, // Максимальная высота (95% экрана)
                                            builder: (BuildContext context,
                                                ScrollController
                                                    scrollController) {
                                              return SingleChildScrollView(
                                                controller: scrollController,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF9CA4AB),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Center(
                                                              child: Text(
                                                                'Арендовать книгу',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            ListTile(
                                                              title:
                                                                  Text(title),
                                                              subtitle:
                                                                  Text(author),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            const Text(
                                                              'Выберите на сколько день будете арендовать:',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            Center(
                                                              child: Text(
                                                                '${localDay.toStringAsFixed(0)} день',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Slider(
                                                              value: localDay,
                                                              min: 1,
                                                              max: 30,
                                                              divisions: 30,
                                                              label:
                                                                  '${localDay.toStringAsFixed(0)} день',
                                                              onChanged: (double
                                                                  value) {
                                                                setModalState(
                                                                    () {
                                                                  localDay =
                                                                      value; // Локальное обновление
                                                                  if (localDay >
                                                                      25) {
                                                                    localPrice =
                                                                        localDay *
                                                                            5;
                                                                  } else if (20 <
                                                                          localDay &&
                                                                      localDay <=
                                                                          25) {
                                                                    localPrice =
                                                                        localDay *
                                                                            10;
                                                                  } else if (15 <
                                                                          localDay &&
                                                                      localDay <=
                                                                          20) {
                                                                    localPrice =
                                                                        localDay *
                                                                            15;
                                                                  } else if (10 <
                                                                          localDay &&
                                                                      localDay <=
                                                                          15) {
                                                                    localPrice =
                                                                        localDay *
                                                                            20;
                                                                  } else if (5 <
                                                                          localDay &&
                                                                      localDay <=
                                                                          10) {
                                                                    localPrice =
                                                                        localDay *
                                                                            25;
                                                                  } else if (0 <
                                                                          localDay &&
                                                                      localDay <=
                                                                          5) {
                                                                    localPrice =
                                                                        localDay *
                                                                            30;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Center(
                                                              child: Text(
                                                                '${localPrice.toStringAsFixed(0)} сом',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  context
                                                                      .read<
                                                                          BookCubit>()
                                                                      .rentBook(
                                                                          book);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue, // Фоновый цвет
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white, // Цвет текста
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          16.0),
                                                                ),
                                                                child: const Text(
                                                                    'Арендовать'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.book),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
