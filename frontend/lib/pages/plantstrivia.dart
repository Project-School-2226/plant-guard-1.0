import 'package:flutter/material.dart';
import 'dart:ui';

class PlantsTrivia extends StatefulWidget {
  const PlantsTrivia({super.key});

  @override
  _PlantsTriviaState createState() => _PlantsTriviaState();
}

class _PlantsTriviaState extends State<PlantsTrivia> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> plantsInfo = [
    {
      "name": "Rice",
      "details":
          "Rice is the staple food of India and covers about one-fourth of the total cropped area. It thrives in regions with high humidity and temperatures between 20°C to 35°C. Rice requires substantial water, often grown in flooded fields. Optimal NPK ratio: 60-40-20. It prefers clayey loam soil that retains water well. The crop cycle lasts about 100-180 days depending on the variety.",
      "imageUrl": 'lib/images/rice.jpeg'
    },
    {
      "name": "Wheat",
      "details":
          "Wheat is the second most important cereal crop in India. It is a staple food in northern and north-western India. Ideal growing conditions include temperatures between 10°C to 25°C and moderate rainfall. Wheat requires well-drained loamy soil. The optimal NPK ratio is 120-60-40. The crop is usually grown in the rabi season, and its cycle lasts around 120-150 days.",
      "imageUrl": 'lib/images/wheat.jpeg'
    },
    {
      "name": "Maize",
      "details":
          "Maize is one of the important cereal crops in India, mainly grown in Karnataka, Andhra Pradesh, and Tamil Nadu. It requires temperatures between 21°C to 27°C and moderate rainfall. Maize thrives in well-drained loamy soil. The optimal NPK ratio is 120-60-40. The crop cycle ranges from 90 to 120 days. Maize is versatile, used for food, fodder, and industrial products.",
      "imageUrl": "lib/images/maize.jpeg"
    },
    {
      "name": "Pulses",
      "details":
          "India is the largest producer and consumer of pulses in the world. Major pulses include chickpeas, pigeon peas, lentils, and mung beans. They thrive in temperatures between 20°C to 30°C and low to moderate rainfall. Pulses prefer well-drained sandy loam soil. The optimal NPK ratio is 20-50-20. The crop cycle varies but typically lasts 90-120 days. Pulses are a crucial source of protein in Indian diets.",
      "imageUrl": "lib/images/pulses.jpeg"
    },
    {
      "name": "Sugarcane",
      "details":
          "Sugarcane is a significant cash crop in India, with Uttar Pradesh, Maharashtra, and Karnataka being the largest producers. Ideal conditions include temperatures between 21°C to 27°C and high humidity. Sugarcane prefers well-drained loamy to clayey soil. The optimal NPK ratio is 60-30-60. The crop cycle is long, lasting about 12 to 18 months. Sugarcane is used for sugar production, ethanol, and as fodder.",
      "imageUrl": "lib/images/sugarcane.jpeg"
    },
    {
      "name": "Cotton",
      "details":
          "Cotton is one of the principal commercial crops in India, and the country is one of the largest producers in the world. It grows well in temperatures between 21°C to 30°C and moderate rainfall. Cotton requires well-drained sandy loam soil. The optimal NPK ratio is 60-30-30. The crop cycle lasts around 150-180 days. Cotton is vital for the textile industry, producing fiber and oil.",
      "imageUrl": "lib/images/cotton.jpeg"
    },
    {
      "name": "Tea",
      "details":
          "Tea is an important beverage crop in India, with Assam, West Bengal, and Tamil Nadu being the major tea-producing states. It requires temperatures between 20°C to 30°C and high humidity. Tea plants thrive in well-drained acidic soil rich in organic matter. The optimal NPK ratio is 4:1:1. The crop can be harvested multiple times a year. Tea is a major export product and a staple in Indian culture.",
      "imageUrl": "lib/images/tea.jpeg"
    },
    {
      "name": "Coffee",
      "details":
          "Coffee is grown in the hilly regions of South India, mainly in Karnataka, Kerala, and Tamil Nadu. It thrives in temperatures between 15°C to 24°C and moderate to high rainfall. Coffee prefers well-drained loamy soil rich in organic matter. The optimal NPK ratio is 20-10-10. The crop cycle lasts around 9-11 months. Coffee is a significant export product and popular beverage.",
      "imageUrl": "lib/images/coffee.jpeg"
    },
    {
      "name": "Spices",
      "details":
          "India is known as the 'land of spices,' producing a variety of spices such as black pepper, cardamom, cloves, and turmeric. These crops generally require temperatures between 10°C to 30°C, varying humidity levels, and an NPK ratio of 20-20-20. Spices prefer well-drained loamy soil. The crop cycles vary widely depending on the spice. Spices are crucial for culinary, medicinal, and cosmetic uses.",
      "imageUrl": "lib/images/spices.jpeg"
    },
    {
      "name": "Oilseeds",
      "details":
          "India is one of the largest producers of oilseeds in the world, with major crops including groundnut, mustard, soybean, and sunflower. Ideal growing conditions include temperatures between 20°C to 30°C and moderate rainfall. Oilseeds prefer well-drained sandy loam to clayey soil. The optimal NPK ratio is 20-40-20. The crop cycle varies from 90 to 150 days. Oilseeds are essential for oil production and as a protein source.",
      "imageUrl": "lib/images/oilseeds.jpeg"
    }
  ];

  List<Map<String, String>> filteredPlantsInfo = [];

  @override
  void initState() {
    super.initState();
    filteredPlantsInfo = plantsInfo; // Initially, all items are shown
    _searchController.addListener(_filterPlants);
  }

  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    final filtered = plantsInfo.where((plant) {
      final plantNameLower = plant["name"]!.toLowerCase();
      return plantNameLower.contains(query);
    }).toList();
    setState(() {
      filteredPlantsInfo = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showPlantDetails(BuildContext context, String name, String details) {
    showDialog(
      context: context,
      barrierColor: Colors.black
          .withOpacity(0), // Makes the overlay outside the dialog translucent
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.transparent, // Makes the dialog background transparent
          content: ClipRect(
            child: // Apply blur effect
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: const Color.fromARGB(31, 36, 35, 35).withOpacity(
                          0.7), // Semi-transparent white background of the dialog
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(
                      //         0.5), // Shadow color with some transparency
                      //     blurRadius: 15, // How blurry the shadow should be
                      //     offset: const Offset(
                      //         0, 3), // Horizontal and vertical offset of shadow
                      //   ),
                      // ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 9.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Text(
                              details,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter a plant name or detail',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 3,
              ),
              itemCount: filteredPlantsInfo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => showPlantDetails(
                      context,
                      filteredPlantsInfo[index]["name"]!,
                      filteredPlantsInfo[index]["details"]!),
                  child: Card(
                    clipBehavior: Clip
                        .antiAlias, // Ensures content is clipped to the shape
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust borderRadius as needed
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                  10), // Match card's borderRadius
                              topRight: Radius.circular(
                                  10), // Match card's borderRadius
                            ),
                            child: Image.asset(
                              filteredPlantsInfo[index]["imageUrl"]!,
                              fit: BoxFit
                                  .cover, // Covers the area, might crop the image
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: Container(
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            filteredPlantsInfo[index]["name"]!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                const Shadow(
                                  offset: Offset(-1.0, -1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
