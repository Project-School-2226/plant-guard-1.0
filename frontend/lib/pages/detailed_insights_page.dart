import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailedInsights extends StatefulWidget {
  const DetailedInsights({super.key});

  @override
  State<DetailedInsights> createState() => _DetailedInsightsState();
}

class _DetailedInsightsState extends State<DetailedInsights> {
  final Map<String, Map<String, String>> attributeData = {
    'Temperature': {
      'Average': '20',
      'Highest': '30',
      'Lowest': '10',
      'Ideal': '22-25',
      'Current': '0',
    },
    'Humidity': {
      'Average': '50',
      'Highest': '70',
      'Lowest': '30',
      'Ideal': '40-60',
      'Current': '0',
    },
    'Soil Moisture': {
      'Average': '40',
      'Highest': '60',
      'Lowest': '20',
      'Ideal': '30-50',
      'Current': '0',
    },
  };
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://fffe-2409-408c-2cc1-b8d1-5f7-9c9c-99c5-c33d.ngrok-free.app/sensors-data/get-from-esp32'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          attributeData['Temperature']?['Current'] =
              double.parse(data['temperature'].toString()).toStringAsFixed(3);
          attributeData['Humidity']?['Current'] =
              double.parse(data['humidity'].toString()).toStringAsFixed(3);
          attributeData['Soil Moisture']?['Current'] =
              data['soilMoisture'].toString(); // Assuming you have this field
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2,
          children: List.generate(attributeData.length, (index) {
            String attribute = attributeData.keys.elementAt(index);
            Map<String, String> values = attributeData[attribute]!;
            return Center(
              // Center to align the container
              child: SizedBox(
                width: 300, // Adjust the width as needed
                child: StatCard(attribute: attribute, values: values),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String attribute;
  final Map<String, String> values;

  const StatCard({Key? key, required this.attribute, required this.values})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Color.fromARGB(255, 174, 244, 198),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(attribute, style: TextStyle(fontWeight: FontWeight.bold)),
            StatLine(label: 'Average', value: values['Average'] ?? 'N/A'),
            StatLine(label: 'Highest', value: values['Highest'] ?? 'N/A'),
            StatLine(label: 'Lowest', value: values['Lowest'] ?? 'N/A'),
            StatLine(label: 'Ideal', value: values['Ideal'] ?? 'N/A'),
            StatLine(
                label: 'Current',
                value: values['Current'] ?? 'N/A',
                isCurrent: true),
          ],
        ),
      ),
    );
  }
}

class StatLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isCurrent;

  const StatLine({
    Key? key,
    required this.label,
    required this.value,
    this.isCurrent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
