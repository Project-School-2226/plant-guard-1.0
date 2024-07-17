// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String temperature = "0.0";
  String humidity = "0.0";
  String soilMoisture = "0.0";
  Map<String, String> npkValues = {'N': "0.0", 'P': "0.0", 'K': "0.0"};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://e23b-49-205-121-131.ngrok-free.app/sensors-data/get-from-esp32'));
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
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DashboardTile(
                  temperature: temperature,
                  humidity: humidity,
                  soilMoisture: soilMoisture,
                  nitrogen: npkValues['N']!,
                  phosphorous: npkValues['P']!,
                  potassium: npkValues['K']!,
                ),
              ],
            ),
          ),
        ));
  }
}

class DashboardTile extends StatelessWidget {
  final String temperature;
  final String humidity;
  final String soilMoisture;
  final String nitrogen;
  final String phosphorous;
  final String potassium;

  // Add more parameters as needed

  DashboardTile({
    Key? key,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
    // Initialize other parameters here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 174, 244, 198),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Plant Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildInfoRow(Icons.thermostat_outlined, 'Temperature', temperature),
          _buildInfoRow(Icons.opacity, 'Humidity', humidity),
          _buildInfoRow(Icons.water_drop, 'Soil Moisture', soilMoisture),
          _buildInfoRow(Icons.wb_cloudy, "Nitrogen", nitrogen),
          _buildInfoRow(Icons.science, "Phosphorous", phosphorous),
          _buildInfoRow(Icons.local_fire_department, "Potassium", potassium),
          // Add more rows for other values
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
