import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/src/features/rentail/presentation/cubit/rentail_cubit.dart';
import 'package:my_books/src/features/rentail/presentation/cubit/rentail_state.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/entities.dart';

class RentBookModal extends StatelessWidget {
  final Book book;
  final double initialDays;
  final ValueChanged<int> onRent;
  final String bookId;

  const RentBookModal({
    Key? key,
    required this.book,
    required this.initialDays,
    required this.onRent,
    required Book my_book,
    required this.bookId,
  }) : super(key: key);

  // Форматирование даты
  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double localDay = initialDays;
    double localPrice = initialDays * 30;
    context.read<RentalCubit>().fetchRentalsByBookId(book.id.toString());

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 1.0, // Полноэкранный режим при скроллинге
          builder: (BuildContext context, ScrollController scrollController) {
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
                      color: AppColors.greyText,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text('Арендовать книгу',
                                style: AppTextStyles.f18w600
                                    .copyWith(color: AppColors.blackText)),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            title: Text(book.gettitle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.author),
                                Text(
                                  'В библиотеке: ${book.copyCount}шт.',
                                  style: AppTextStyles.f14w400
                                      .copyWith(color: AppColors.blue),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text('Выберите на сколько день будете арендовать:',
                              style: AppTextStyles.f14w400
                                  .copyWith(color: AppColors.greyText)),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              '${localDay.toStringAsFixed(0)} день',
                              style: AppTextStyles.f24w700
                                  .copyWith(color: AppColors.blue),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Slider(
                            value: localDay,
                            min: 1,
                            max: 30,
                            divisions: 30,
                            label: '${localDay.toStringAsFixed(0)} день',
                            onChanged: (double value) {
                              setState(() {
                                localDay = value; // Локальное обновление
                                localPrice = localDay * 30;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              '${localPrice.toStringAsFixed(0)} сом',
                              style: AppTextStyles.f24w700
                                  .copyWith(color: AppColors.blue),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: book.copyCount > 0
                                      ? () {
                                          onRent(localDay.toInt());
                                          Navigator.pop(context);
                                        }
                                      : null, // Кнопка будет неактивной, если copyCount <= 0
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: book.copyCount > 0
                                        ? AppColors.blue
                                        : AppColors
                                            .greyText, // Цвет для неактивного состояния
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                  ),
                                  child: const Text('Арендовать'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BlocBuilder<RentalCubit, RentalState>(
                                  builder: (context, state) {
                                    if (state is RentalLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is RentalListLoaded) {
                                      final rentals = state.rentals;

                                      if (rentals.isEmpty) {
                                        return const Center(
                                          child: Text(
                                              'Нет активных аренд для этой книги.'),
                                        );
                                      }

                                      return SizedBox(
                                        height: 600,
                                        child: ListView.builder(
                                          itemCount: rentals.length,
                                          itemBuilder: (context, index) {
                                            final rental = rentals[index];
                                            return ListTile(
                                              title: Text(
                                                  'Пользователь: ${rental.userName}'), // Имя вместо userId
                                              subtitle: Column(
                                                children: [
                                                  Text(
                                                    'Дата аренды: ${formatDate(rental.rentalDate)}',
                                                    style: TextStyle(
                                                        color: AppColors.red),
                                                  ),
                                                ],
                                              ),
                                              trailing: rental.returnDate !=
                                                      null
                                                  ? Text(
                                                      'Возврат: ${rental.dueDate?.toLocal()}'
                                                          .split(' ')[0],
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.blue),
                                                    )
                                                  : const Text('Аренда активна',
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.red)),
                                            );
                                          },
                                        ),
                                      );
                                    } else if (state is RentalError) {
                                      return Center(
                                          child:
                                              Text('Ошибка: ${state.message}'));
                                    }

                                    return const Center(
                                        child: Text('Неизвестное состояние.'));
                                  },
                                ),
                              ),
                            ],
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
  }
}
