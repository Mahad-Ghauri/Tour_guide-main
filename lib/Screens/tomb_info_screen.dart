import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';

class TombInfoScreen extends StatelessWidget {
  // Hardcoded data for Tomb of Shah Rukh-e-Alaam and other Multan tombs
  final String description = """
The Tomb of Shah Rukh-e-Alaam, located in Multan, Pakistan, is a historic shrine dedicated to the revered Sufi saint Shah Rukh-e-Alaam. Built in the 14th century, this beautifully adorned structure features intricate tile work and a serene courtyard, attracting devotees and tourists alike. The tomb is a symbol of Multan's rich cultural and spiritual heritage.
""";

  final List<String> pictures = [
    "assets/images/tomb1.jpg",
    "assets/images/tomb2.jpg",
    "assets/images/tomb3.jpg",
    "assets/images/tomb4.jpg",
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
        title: const Text('Tomb Information'),
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
                  'Tomb of Shah Rukh-e-Alaam',
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ), // Replace with your HomeScreen widget
                        (route) => false, // Clears the navigation stack
                      );
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
