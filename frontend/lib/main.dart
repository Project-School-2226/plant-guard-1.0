import 'package:flutter/material.dart';
import 'package:plant_guard/pages/chat_page.dart';
import 'package:plant_guard/pages/intro_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IntroPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
