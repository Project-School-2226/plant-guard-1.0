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
  double temperature = 0.0;
  double humidity = 0.0;
  double soilMoisture = 0.0;
  Map<String, double> npkValues = {'N': 0.0, 'P': 0.0, 'K': 0.0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2, // Display 2 items per row
        childAspectRatio: 1.0, // Makes each item square-shaped
        padding: EdgeInsets.all(8.0),
        mainAxisSpacing: 8.0, // Spacing between items vertically
        crossAxisSpacing: 8.0, // Spacing between items horizontally
        children: <Widget>[
          _buildValueTile('Temperature', '$temperature°C'),
          _buildValueTile('Humidity', '$humidity%'),
          _buildValueTile('Soil Moisture', '$soilMoisture%'),
          _buildValueTile('Nitrogen', '${npkValues['N']}'),
          _buildValueTile('Phosphorous', '${npkValues['P']}'),
          _buildValueTile('Potassium', '${npkValues['K']}'),
        ],
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

Widget _buildValueTile(String title, String value) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF5ada86),
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8), // Provides spacing between the title and value
          Text(value, style: TextStyle(fontSize: 20)),
        ],
      ),
    ),
  );
}
