// File: genre_filter_widget.dart (Widget)
import 'package:flutter/material.dart';
import 'package:my_books/src/core/constants/colors.dart';

class GenreFilterWidget extends StatelessWidget {
  final List<String> genres = ['Все', 'Программирование', 'Adventure', 'Drama'];
  final String selectedGenre;
  final Function(String) onGenreSelected;

  GenreFilterWidget({
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Row(
          children: genres.map((genre) {
            final isSelected = genre == selectedGenre;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isSelected ? AppColors.blue : AppColors.grey,
                  foregroundColor:
                      isSelected ? AppColors.white : AppColors.blackText,
                ),
                onPressed: () => onGenreSelected(genre),
                child: Text(genre),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
