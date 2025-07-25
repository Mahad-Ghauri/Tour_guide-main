// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_application/Screens/interface/home_screen.dart';

class GhantaGharInfoScreen extends StatelessWidget {
  // Hardcoded data for Ghanta Ghar Multan
  final String description = """
Ghanta Ghar, also known as the Clock Tower of Multan, is a historic landmark in the heart of Multan, Pakistan. Built during the British colonial period in the 1880s, it stands as a symbol of the city's heritage. The structure features a blend of Victorian and Indo-Saracenic architecture, with a clock on each of its four sides. It is surrounded by the bustling markets of Multan, making it a central point for both locals and visitors.
""";

  final List<String> pictures = [
    "assets/images/ghar1.jpg",
    "assets/images/ghar2.jpg",
    "assets/images/ghar3.jpg",
  ];

  final List<String> foodRecommendations = [
    "Sohan Halwa from Famous Sohan Halwa Shop",
    "Multani Mutton from Pakwan Centre",
    "Lassi from Punjabi Lassi House",
  ];

  final List<Map<String, String>> allTombs = [
    {
      "name": "Tomb of Shah Rukh-e-Alaam",
      "description": "A 14th-century Sufi shrine with intricate tile work.",
    },
    {
      "name": "Tomb of Bahauddin Zakariya",
      "description": "A grand mausoleum of a prominent Sufi saint.",
    },
    {
      "name": "Tomb of Shamsuddin Sabzwari",
      "description":
          "Known for its unique architecture and historical significance.",
    },
    {
      "name": "Tomb of Rukn-e-Alam",
      "description": "A masterpiece of Multani architecture with a green dome.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghanta Ghar Information'),
        backgroundColor: const Color(0xFF559CB2),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF559CB2), Color(0xFFB3E5FC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Ghanta Ghar Multan',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pictures',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    viewportFraction: 0.8,
                  ),
                  items:
                      pictures.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(imagePath, fit: BoxFit.cover),
                            );
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Food Recommendations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...foodRecommendations.map(
                  (food) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      food,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'All Tombs of Multan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...allTombs.map(
                  (tomb) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tomb['name']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          tomb['description']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF559CB2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/':
            (context) =>
                HomeScreen(), // Replace with your actual HomeScreen widget
        '/ghantaGharInfo': (context) => GhantaGharInfoScreen(),
      },
    ),
  );
}
