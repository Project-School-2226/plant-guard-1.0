import 'package:chat_gpt_chat_app/chat_page.dart';
import 'package:flutter/material.dart';
// import goats

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// hi this is vishal