import 'package:flutter/material.dart';
import 'package:plant_guard/pages/intro_page.dart';
import 'package:plant_guard/pages/settings_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Image.asset(
                'lib/images/PlantGuard_logo.png',
                width: 210,
              )),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              //other pages

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      title: Text('Settings',
                          style: TextStyle(color: Colors.black))),
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
                    color: Colors.black,
                  ),
                  title: Text('Logout', style: TextStyle(color: Colors.black))),
            ),
          ),
        ],
      ),
    );
  }
}
