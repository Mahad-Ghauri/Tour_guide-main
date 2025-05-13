// // screens/destination_info_screen.dart
// import 'package:flutter/material.dart';
// import '../controllers/destination_controller.dart';
// import 'package:tour_guide_application/data/destination_data.dart';


// class DestinationInfoScreen extends StatefulWidget {
//   final String placeId;

//   const DestinationInfoScreen({super.key, required this.placeId});

//   @override
//   State<DestinationInfoScreen> createState() => _DestinationInfoScreenState();
// }

// class _DestinationInfoScreenState extends State<DestinationInfoScreen> {
//   late DestinationController _controller;
//   DestinationInfo? _destinationInfo;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = DestinationController();
//     _loadDestination();
//   }

//   Future<void> _loadDestination() async {
//     try {
//       final info = await _controller.getDestinationById(widget.placeId);
//       setState(() {
//         _destinationInfo = info;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _loading = false;
//       });
//       print('Error loading destination: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Center(child: CircularProgressIndicator());

//     if (_destinationInfo == null) {
//       return const Center(child: Text("Destination not found."));
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(_destinationInfo!.placeName)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("History", style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text(_destinationInfo!.history),
//             const SizedBox(height: 16),
//             Text("Recommended Foods", style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             ..._destinationInfo!.foodRecommendations
//                 .map((food) => Text("- $food")),
//             const SizedBox(height: 16),
//             Text("Gallery", style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 200,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _destinationInfo!.pictures.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Image.network(_destinationInfo!.pictures[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TombInfoScreen extends StatelessWidget {
  // Hardcoded data for Tomb of Shah Rukh-e-Alaam and other Multan tombs
  final String description = """
The Tomb of Shah Rukh-e-Alaam, located in Multan, Pakistan, is a historic shrine dedicated to the revered Sufi saint Shah Rukh-e-Alaam. Built in the 14th century, this beautifully adorned structure features intricate tile work and a serene courtyard, attracting devotees and tourists alike. The tomb is a symbol of Multan's rich cultural and spiritual heritage.
""";

  final List<String> pictures = [
    "https://example.com/tomb1.jpg",
    "https://example.com/tomb2.jpg",
    "https://example.com/tomb3.jpg",
  ];

  final List<String> foodRecommendations = [
    "Sohan Halwa from Famous Sohan Halwa Shop",
    "Multani Mutton from Pakwan Centre",
    "Lassi from Punjabi Lassi House",
  ];

  final List<Map<String, String>> allTombs = [
    {"name": "Tomb of Shah Rukh-e-Alaam", "description": "A 14th-century Sufi shrine with intricate tile work."},
    {"name": "Tomb of Bahauddin Zakariya", "description": "A grand mausoleum of a prominent Sufi saint."},
    {"name": "Tomb of Shamsuddin Sabzwari", "description": "Known for its unique architecture and historical significance."},
    {"name": "Tomb of Rukn-e-Alam", "description": "A masterpiece of Multani architecture with a green dome."},
  ];

  TombInfoScreen({super.key});

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
                  'Tomb of Shah Rukh-e-Alaam',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
                ...pictures.map((url) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        url,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    )),
                const SizedBox(height: 20),
                Text(
                  'Food Recommendations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                ...foodRecommendations.map((food) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        food,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    )),
                const SizedBox(height: 20),
                Text(
                  'All Tombs of Multan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                ...allTombs.map((tomb) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tomb['name']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            tomb['description']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
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