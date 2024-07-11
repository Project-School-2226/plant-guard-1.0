import 'package:flutter/material.dart';
import 'package:plant_guard/Components/dashboard_drawer.dart';
import 'package:plant_guard/pages/chat_page.dart';
import 'package:plant_guard/pages/dashboard.dart';
import 'package:plant_guard/pages/profile_page.dart';
import 'package:plant_guard/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final PageController pageController = PageController();
  final List<String> pageTitles = [
    'PlantGuard',
    'Settings',
    'Profile',
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: selectedIndex == 0
            ? ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF1D9621), // Color(0xFF1D9621
                    const Color.fromARGB(255, 29, 150, 33),
                    Colors.black,
                  ], // Define your gradient colors here
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  pageTitles[selectedIndex],
                  style: TextStyle(
                    // Text color must be white (or any other color) to ensure the gradient is visible
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Title(
                color: Colors.black, child: Text(pageTitles[selectedIndex])),
        automaticallyImplyLeading:
            false, // Assuming Dashboard is the first page (index 0)

        // Other AppBar properties
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: <Widget>[
          // Your page widgets here
          Dashboard(),
          SettingsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Change the background color
        selectedItemColor: Colors.green, // Change the selected item color
        unselectedItemColor: Colors.grey, // Change the unselected item color
        currentIndex: selectedIndex,
        onTap: navigateBottomBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Icon(
          Icons.chat,
          color: Colors.black,
        ),
        backgroundColor: Colors.green, // Customize your FAB color
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Position of the FAB
    );
  }
}
