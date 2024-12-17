import 'package:flutter/material.dart';
import 'package:my_books/src/core/constants/colors.dart';
import 'package:my_books/src/features/home/presentation/pages/add_book.dart';
import 'package:my_books/src/features/home/presentation/pages/books.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  int _selectedIndex = 0; // Индекс текущей страницы

  // Список страниц
  static final List<Widget> _pages = <Widget>[
    BookScreen(),
    const Center(child: Text('Избранное', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Настройки', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Изменяем индекс при нажатии
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список Книг'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddBookScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Отображаем текущую страницу
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Книги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex, // Указываем текущий индекс
        selectedItemColor: AppColors.blue, // Цвет выбранного элемента
        unselectedItemColor: AppColors.grey, // Цвет невыбранных элементов
        onTap: _onItemTapped, // Обработчик нажатий
      ),
    );
  }
}
