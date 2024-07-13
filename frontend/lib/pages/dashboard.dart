// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Timer? _timer;
  String temperature = "0.0";
  String humidity = "0.0";
  String soilMoisture = "0.0";
  Map<String, String> npkValues = {'N': "0.0", 'P': "0.0", 'K': "0.0"};

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupPeriodicRequest();
  }

  void _setupPeriodicRequest() {
    const twoMinutes = Duration(minutes: 2);
    _timer = Timer.periodic(twoMinutes, (Timer t) => fetchData());
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://d355-183-82-97-138.ngrok-free.app/sensors-data/get-from-esp32'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          temperature = data['temperature'].toString();
          humidity = data['humidity'].toString();
          soilMoisture =
              data['soilMoisture'].toString(); // Assuming you have this field
          npkValues = {
            'N': data['N'].toString(),
            'P': data['P'].toString(),
            'K': data['K'].toString(),
          };
        });
        // Save data to SharedPreferences
        _saveData();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperature', temperature);
    await prefs.setString('humidity', humidity);
    await prefs.setString(
        'soilMoisture', soilMoisture); // Assuming you want to save this
    await prefs.setString('N', npkValues['N']!);
    await prefs.setString('P', npkValues['P']!);
    await prefs.setString('K', npkValues['K']!);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      temperature = prefs.getString('temperature') ?? "0.0";
      humidity = prefs.getString('humidity') ?? "0.0";
      soilMoisture = prefs.getString('soilMoisture') ??
          "0.0"; // Assuming you want to load this
      npkValues = {
        'N': prefs.getString('N') ?? "0.0",
        'P': prefs.getString('P') ?? "0.0",
        'K': prefs.getString('K') ?? "0.0",
      };
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          _buildValueTile('Temperature', '$temperature°C', 20, 30),
          _buildValueTile('Humidity', '$humidity%', 50, 100),
          _buildValueTile('Soil Moisture', '$soilMoisture%', 0, 100),
          _buildValueTile('Nitrogen', '${npkValues['N']}', 10, 20),
          _buildValueTile('Phosphorous', '${npkValues['P']}', 5, 10),
          _buildValueTile('Potassium', '${npkValues['K']}', 2, 10),
        ],
      ),
    );
  }
}

Widget _buildValueTile(String title, String value, double low, double high) {
  double val = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

  // Step 2: Determine the gradient based on the value
  LinearGradient gradient;
  if (val <= low) {
    // Assuming 20.0 as the low threshold
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.red,
        Colors.red,
      ],
    );
  } else if (val >= high) {
    // Assuming 80.0 as the high threshold
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.red, Colors.red],
    );
  } else {
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.green, Colors.lightGreenAccent],
    );
  }
  return Container(
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
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
          Icon(Icons.trending_up, color: Colors.black), // Example icon
          SizedBox(height: 5), // Adjust spacing as needed
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(
                  255, 31, 30, 30), // Brighter text color for the title
            ),
          ),
          SizedBox(height: 10), // Provides spacing between the title and value
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(
                  255, 84, 84, 84), // Slightly dim color for the value
            ),
          ),
        ],
      ),
    ),
  );
}
