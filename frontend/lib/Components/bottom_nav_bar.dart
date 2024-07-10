// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        color: Colors.black,
        activeColor: Colors.black,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Color.fromARGB(255, 91, 187, 94),
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        padding: EdgeInsets.symmetric(
            horizontal: 13, vertical: 14), // Reduced padding
        gap: 8,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.chat,
            text: 'ChatBot',
          ),
          GButton(
            icon: Icons.info,
            text: 'Trivia',
          )
        ],
      ),
    );
  }
}
