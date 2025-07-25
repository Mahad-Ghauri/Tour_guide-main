import 'package:flutter/material.dart';

class KhoniBurjInfoScreen extends StatelessWidget {
  // Hardcoded data for Khoni Burj Multan
  final String description = """
Khoni Burj, also known as the "Bloody Bastion," is a historic tower in Multan, Pakistan. It is part of the ancient city walls and dates back to the pre-Mughal era, with significant historical events tied to its name. The structure is famous for its robust architecture and the stories of battles that took place around it. Today, it stands as a reminder of Multan's defensive past and is a popular spot for history enthusiasts.
""";

  final List<String> pictures = [
    "https://example.com/khoni_burj1.jpg",
    "https://example.com/khoni_burj2.jpg",
    "https://example.com/khoni_burj3.jpg",
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

   KhoniBurjInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Khoni Burj Multan',
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
                ...pictures.map(
                  (url) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      url,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
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
