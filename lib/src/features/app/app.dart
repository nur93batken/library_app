import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../home/presentation/pages/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        useMaterial3: true,
      ),
      home: const MyHome(),
    );
  }
}
