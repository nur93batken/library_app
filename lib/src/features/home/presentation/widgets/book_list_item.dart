import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/entities/entities.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookListItem({
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.gettitle,
                style:
                    AppTextStyles.f16w600.copyWith(color: AppColors.blackText),
              ),
              const SizedBox(height: 4),
              Text(
                'Автор: ${book.author}',
                style:
                    AppTextStyles.f14w400.copyWith(color: AppColors.greyText),
              ),
              Text(
                'Жанр: ${book.genres}',
                style:
                    AppTextStyles.f14w400.copyWith(color: AppColors.greyText),
              ),
              Text(
                'Год издания: ${book.date}',
                style:
                    AppTextStyles.f14w400.copyWith(color: AppColors.greyText),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'В библиотеке: ${book.copyCount}шт.',
                    style:
                        AppTextStyles.f14w400.copyWith(color: AppColors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_border_outlined),
                    onPressed: () {
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
                ],
              ),
            ],
          ),
          leading: const Icon(Icons.book),
        ),
      ),
    );
  }
}
