// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // Optional: for a notch in the middle
      child: Container(
        height: 60, // Adjust the height to fit your design
        child: GNav(
          backgroundColor: Color.fromARGB(255, 74, 73, 73),
          color: Colors.black,
          activeColor: Colors.black,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Color(0xFF5ada86),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          tabBorderRadius: 16,
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          tabs: const [
            GButton(
              icon: Icons.dashboard,
              text: 'Dashboard',
            ),
            GButton(
              icon: Icons.chat,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
          // Your GNav items here
        ),
      ),
    );
  }
}
