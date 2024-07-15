import 'package:flutter/material.dart';
import 'dart:ui';


class PlantsTrivia extends StatelessWidget {
  PlantsTrivia({super.key});

    final List<Map<String, String>> plantsInfo = [
  {
    "name": "Rice",
    "details": "Rice is the staple food of India and covers about one-fourth of the total cropped area.",
    "imageUrl": 'lib/images/rice.jpeg'
  },
  {
    "name": "Wheat",
    "details": "Wheat is the second most important cereal crop in India. It is a staple food in northern and north-western India.",
    "imageUrl": 'lib/images/wheat.jpeg'
  },
  {
    "name": "Maize",
    "details": "Maize is one of the important cereal crops in India and is mainly grown in the states of Karnataka, Andhra Pradesh, and Tamil Nadu.",
    "imageUrl": "lib/images/maize.jpeg"
  },
  {
    "name": "Pulses",
    "details": "India is the largest producer and consumer of pulses in the world. Major pulses grown are chickpeas, pigeon peas, lentils, and mung beans.",
    "imageUrl": "lib/images/pulses.jpeg"
  },
  {
    "name": "Sugarcane",
    "details": "Sugarcane is a significant cash crop in India, with Uttar Pradesh, Maharashtra, and Karnataka being the largest producers.",
    "imageUrl": "lib/images/sugarcane.jpeg"
  },
  {
    "name": "Cotton",
    "details": "Cotton is one of the principal commercial crops in India, and the country is one of the largest producers in the world.",
    "imageUrl": "lib/images/cotton.jpeg"
  },
  {
    "name": "Tea",
    "details": "Tea is an important beverage crop in India, with Assam, West Bengal, and Tamil Nadu being the major tea-producing states.",
    "imageUrl": "lib/images/tea.jpeg"
  },
  {
    "name": "Coffee",
    "details": "Coffee is grown in the hilly regions of South India, mainly in Karnataka, Kerala, and Tamil Nadu.",
    "imageUrl": "lib/images/coffee.jpeg"
  },
  {
    "name": "Spices",
    "details": "India is known as the 'land of spices,' producing a variety of spices such as black pepper, cardamom, cloves, and turmeric.",
    "imageUrl": "lib/images/spices.jpeg"
  },
  {
    "name": "Oilseeds",
    "details": "India is one of the largest producers of oilseeds in the world, with major crops including groundnut, mustard, soybean, and sunflower.",
    "imageUrl": "lib/images/oilseeds.jpeg"
  }
];


  void showPlantDetails(BuildContext context, String name, String details) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0), // Makes the overlay outside the dialog translucent
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Makes the dialog background transparent
          content: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Apply blur effect
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(31, 36, 35, 35).withOpacity(0.7), // Semi-transparent white background of the dialog
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
                      spreadRadius: 2, // Extent of shadow spread
                      blurRadius: 15, // How blurry the shadow should be
                      offset: const Offset(0, 3), // Horizontal and vertical offset of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Makes the container wrap its content
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(name, style: const TextStyle(fontSize: 24,
                        color: Colors.white,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:9.0, left:16.0, right:16.0, bottom: 16.0),
                      child: Text(
                        details,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          childAspectRatio: 4 / 3, // Adjust based on your image size and text content
        ),
        itemCount: plantsInfo.length,
        itemBuilder: (context, index) {
  return InkWell(
    onTap: () => showPlantDetails(context, plantsInfo[index]["name"]!, plantsInfo[index]["details"]!),
    child: Card(
      clipBehavior: Clip.antiAlias, // Ensures content is clipped to the shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Adjust borderRadius as needed
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), // Match card's borderRadius
                topRight: Radius.circular(10), // Match card's borderRadius
              ),
              child: Image.asset(
                plantsInfo[index]["imageUrl"]!,
                fit: BoxFit.cover, // Covers the area, might crop the image
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
              plantsInfo[index]["name"]!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }
}