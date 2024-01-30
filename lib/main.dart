import 'package:flutter/material.dart';
import 'package:shopping_app/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey.shade500,
          brightness: Brightness.dark,
          surface: Colors.grey.shade700,
        ),
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
    );
  }
}
