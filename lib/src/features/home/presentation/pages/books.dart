import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/src/core/constants/constants.dart';
import 'package:my_books/src/features/home/presentation/pages/detal_book.dart';
import '../../data/models/book.dart';
import '../cubit/book_cubit.dart';
import '../widgets/filter_books.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookListWithFilterScreenState createState() =>
      _BookListWithFilterScreenState();
}

class _BookListWithFilterScreenState extends State<BookScreen> {
  String selectedGenre = 'Все'; // По умолчанию выбран "Все"
  double _currentDay = 5; // Начальное значение день

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Фильтры жанров
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GenreFilterWidget(
              selectedGenre: selectedGenre,
              onGenreSelected: (genre) {
                setState(() {
                  selectedGenre = genre;
                });
              },
            ),
          ),
          // Список книг
          Expanded(
            child: BlocBuilder<BookCubit, List<Book>>(
              builder: (context, books) {
                // Фильтрация книг по выбранному жанру
                final filteredBooks = selectedGenre == 'Все'
                    ? books
                    : books
                        .where((book) => book.genres.contains(selectedGenre))
                        .toList();

                if (filteredBooks.isEmpty) {
                  return const Center(child: Text('Нет книг для отображения.'));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailsScreen(book: book),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.gettitle,
                                  style: AppTextStyles.f16w600
                                      .copyWith(color: AppColors.blackText),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Автор: ${book.author}',
                                  style: AppTextStyles.f14w400
                                      .copyWith(color: AppColors.greyText),
                                ),
                                Text(
                                  'Жанр: ${book.genres}',
                                  style: AppTextStyles.f14w400
                                      .copyWith(color: AppColors.greyText),
                                ),
                                Text(
                                  'Год издания: ${book.date}',
                                  style: AppTextStyles.f14w400
                                      .copyWith(color: AppColors.greyText),
                                ),
                                const Divider(
                                  color: Colors.grey, // Цвет линии
                                  thickness: 1, // Толщина линии
                                  height:
                                      16, // Пространство перед и после линии
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'В библиотеке: ${book.copyCount}шт.',
                                      style: AppTextStyles.f14w400
                                          .copyWith(color: AppColors.blue),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.star_border_outlined),
                                      onPressed: () {
                                        // Обработка нажатия на кнопку "Информация"
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(book.gettitle),
                                            content:
                                                Text('Автор: ${book.author}'),
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
                                            double localPrice = 100;
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
                                                  builder: (BuildContext
                                                          context,
                                                      ScrollController
                                                          scrollController) {
                                                    return SingleChildScrollView(
                                                      controller:
                                                          scrollController,
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF9CA4AB),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16.0),
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
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          16),
                                                                  ListTile(
                                                                    title: Text(
                                                                        title),
                                                                    subtitle: Text(
                                                                        author),
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  const Text(
                                                                    'Выберите на сколько день будете арендовать:',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  Center(
                                                                    child: Text(
                                                                      '${localDay.toStringAsFixed(0)} день',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  Slider(
                                                                    value:
                                                                        localDay,
                                                                    min: 1,
                                                                    max: 30,
                                                                    divisions:
                                                                        30,
                                                                    label:
                                                                        '${localDay.toStringAsFixed(0)} день',
                                                                    onChanged:
                                                                        (double
                                                                            value) {
                                                                      setModalState(
                                                                          () {
                                                                        localDay =
                                                                            value; // Локальное обновление
                                                                        localPrice =
                                                                            localDay *
                                                                                30;
                                                                      });
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  Center(
                                                                    child: Text(
                                                                      '${localPrice.toStringAsFixed(0)} сом',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .read<BookCubit>()
                                                                            .rentBook(book);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blue, // Фоновый цвет
                                                                        foregroundColor:
                                                                            Colors.white, // Цвет текста
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
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
