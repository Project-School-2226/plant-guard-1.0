import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String backendMessage = "Loading...";
  String temperature = "0.0";
  String humidity = "0.0";

  Map<String, String> npkValues = {'N': "0.0", 'P': "0.0", 'K': "0.0"};
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://1600-183-82-97-138.ngrok-free.app/sensors-data/get-from-esp32'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          temperature = data['temperature'].toString();
          humidity = data['humidity'].toString();
          npkValues = {
            'N': data['N'].toString(),
            'P': data['P'].toString(),
            'K': data['K'].toString(),
          };
          // Assuming backendMessage is declared and used to show success/failure messages
          backendMessage = 'Data fetched successfully';
        });
      } else {
        setState(() {
          backendMessage = 'Failed to fetch data';
        });
      }
    } catch (e) {
      setState(() {
        backendMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
          _buildValueTile('Temperature', '$temperature°C'),
          _buildValueTile('Humidity', '$humidity%'),
          // _buildValueTile('Soil Moisture', '$soilMoisture%'),
          _buildValueTile('Nitrogen', '${npkValues['N']}'),
          _buildValueTile('Phosphorous', '${npkValues['P']}'),
          _buildValueTile('Potassium', '${npkValues['K']}'),
        ],
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
