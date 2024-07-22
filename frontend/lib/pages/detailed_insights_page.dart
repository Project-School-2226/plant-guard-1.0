import 'package:flutter/material.dart';

class DetailedInsights extends StatefulWidget {
  const DetailedInsights({super.key});

  @override
  State<DetailedInsights> createState() => _DetailedInsightsState();
}

class _DetailedInsightsState extends State<DetailedInsights> {
  final List<String> attributes = [
    'Temperature',
    'Humidity',
    'Soil Moisture',
    'Nitrogen',
    'Phosphorous',
    'Potassium',
  ];

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
          children: List.generate(attributes.length, (index) {
            return Center(
              // Center to align the container
              child: SizedBox(
                width: 300, // Adjust the width as needed
                child: StatCard(attribute: attributes[index]),
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

  const StatCard({Key? key, required this.attribute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(attribute, style: TextStyle(fontWeight: FontWeight.bold)),
            const StatLine(label: 'Average', value: '20'),
            const StatLine(label: 'Highest', value: '30'),
            const StatLine(label: 'Lowest', value: '10'),
            const StatLine(label: 'Ideal', value: '22-25'),
            const StatLine(label: 'Current', value: '21', isCurrent: true), 
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
        Text(label,
            style: TextStyle(color: isCurrent ? Colors.blue : Colors.black)),
        Text(value),
      ],
    );
  }
}
