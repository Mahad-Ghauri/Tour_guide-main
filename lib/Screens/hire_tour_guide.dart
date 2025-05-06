import 'package:flutter/material.dart';
import 'package:tour_guide_application/Controllers/guide_booking_controller.dart';

class HireTourGuideScreen extends StatefulWidget {
  const HireTourGuideScreen({super.key});

  @override
  State<HireTourGuideScreen> createState() => _HireTourGuideScreenState();
}

class _HireTourGuideScreenState extends State<HireTourGuideScreen> {
  final TextEditingController _priceFilterController = TextEditingController();
  bool _sortAscending = true;

  // List of all guides
  List<Map<String, dynamic>> allGuides = List.generate(15, (index) {
    return {
      "name": "Guide ${index + 1}",
      "desc":
          "Experienced and friendly guide with knowledge of local history and culture.",
      "price": 100 + (index * 20),
      "image": "assets/images/guide${index + 1}.jpg", // Use local image paths
    };
  });

  // List of guides filtered by price
  List<Map<String, dynamic>> filteredGuides = [];

  @override
  void initState() {
    super.initState();
    filteredGuides = List.from(allGuides); // Initialize filtered guides
  }

  // Function to filter guides based on the price
  void filterGuides(String priceText) {
    final price = int.tryParse(priceText);
    if (price == null) {
      setState(() {
        filteredGuides = List.from(allGuides); // Reset to all guides
      });
    } else {
      setState(() {
        filteredGuides =
            allGuides.where((guide) => guide['price'] <= price).toList();
      });
    }
  }

  // Function to sort guides by price
  void sortGuides() {
    setState(() {
      _sortAscending = !_sortAscending;
      filteredGuides.sort(
        (a, b) =>
            _sortAscending
                ? a['price'].compareTo(b['price'])
                : b['price'].compareTo(a['price']),
      );
    });
  }

  // Function to show guide details in a dialog
  void showGuideDetails(Map<String, dynamic> guide) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(guide['name']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  guide['image'],
                  fit: BoxFit.cover,
                ), // Using Image.asset for local images
                const SizedBox(height: 10),
                Text(guide['desc']),
                const SizedBox(height: 10),
                Text(
                  "Price: \$${guide['price']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final controller = GuideBookingController();
                  try {
                    // Call the method to book the guide
                    await controller.bookGuide(
                      guideName: guide['name'],
                      price: guide['price'],
                      imageUrl: guide['image'],
                    );
                    Navigator.pop(context); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "✅ ${guide['name']} booked successfully!",
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context); // Close the dialog in case of error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Booking failed: $e")),

                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Book Now"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hire a Tour Guide"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: "Sort by Price",
            onPressed: sortGuides,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _priceFilterController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "🔍 Filter by max price",
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _priceFilterController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _priceFilterController.clear();
                            filterGuides('');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterGuides,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // Adjusted aspect ratio
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredGuides.length,
              itemBuilder: (context, index) {
                final guide = filteredGuides[index];
                return GestureDetector(
                  onTap: () => showGuideDetails(guide),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              guide['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            guide['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guide['desc'],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${guide['price']}",
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("You booked ${guide['name']}!"),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text("Book Now"),
                            ),
                          ),
                        ],
                      ),
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
