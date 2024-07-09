import 'package:flutter/material.dart';
import 'package:plant_guard/pages/intro_page.dart';
import 'package:plant_guard/pages/profile_page.dart';
import 'package:plant_guard/pages/settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String backendMessage = "Loading...";

  // @override
  // void initState() {
  //   super.initState();
  //   fetchMessage();
  // }

  // Future<void> fetchMessage() async {
  //   final response = await http.get(Uri.parse("http://localhost:5000/data"));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       backendMessage = data['message']; // Assuming the message is in a field called 'message'
  //     });
  //   } else {
  //     setState(() {
  //       backendMessage = "Failed to load message";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(backendMessage), // Display the message from the backend
      ),
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage()), // Replace ProfilePage with your profile page widget
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 62, 38, 33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                    child: Image.asset(
                  'lib/images/plantLogo.png',
                  width: 150,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                //other pages

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text('Settings',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntroPage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title:
                        Text('Logout', style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
