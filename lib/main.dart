import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_books/src/features/app/app.dart';
import 'firebase_options.dart'; // Сгенерированный файл

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
