import 'package:flutter/material.dart';
import 'package:tour_guide_application/Controllers/guide_booking_controller.dart';
import 'package:tour_guide_application/Screens/billing_detail_screen.dart';
import 'package:tour_guide_application/Screens/billing_detail_screen.dart';


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
                  "Price: Rs ${guide['price']}",
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
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillingDetailsScreen(
                        guideName: guide['name'],
                        price: guide['price'],
                        imageUrl: guide['image'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF559CB2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                ),
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
        backgroundColor: Color(0xFF559CB2),
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
      body: Container(
        color: Colors.white,
        child: Column(
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                onChanged: filterGuides,
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72, // Taller cards for better image display
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filteredGuides.length,
                itemBuilder: (context, index) {
                  final guide = filteredGuides[index];
                  return GestureDetector(
                    onTap: () => showGuideDetails(guide),
                    child: SizedBox(
                      height: 240,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 3,
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.1,
                                  child: Image.asset(
                                    guide['image'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.blue[50],
                                      child: const Icon(Icons.person, size: 40, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    guide['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    guide['desc'],
                                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Rs ${guide['price']}",
                                    style: const TextStyle(
                                      color: Color(0xFF559CB2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BillingDetailsScreen(
                                          guideName: guide['name'],
                                          price: guide['price'],
                                          imageUrl: guide['image'],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF559CB2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text("Book Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
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
      ),
    );
  }
}