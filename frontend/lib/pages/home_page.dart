import 'package:flutter/material.dart';
import 'package:plant_guard/Components/bottom_nav_bar.dart';
import 'package:plant_guard/pages/chat_page.dart';
import 'package:plant_guard/pages/dashboard.dart';
import 'package:plant_guard/pages/plantstrivia.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    //shop page
    const Dashboard(),
    //cart page
    const ChatScreen(),
    //trivia page
    PlantsTrivia()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: pages[selectedIndex],
      
    );
  }
}
