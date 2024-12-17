import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/presentation/cubit/book_cubit.dart';
import '../home/presentation/pages/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookCubit()..loadBooks(),
      child: const MaterialApp(
        home: MyHome(),
      ),
    );
  }
}
