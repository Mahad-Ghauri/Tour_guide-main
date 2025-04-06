import 'package:flutter/material.dart';

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
      "image": "https://via.placeholder.com/150",
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
                Image.network(guide['image']),
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
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You booked ${guide['name']}!")),
                  );
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
                childAspectRatio: 0.70,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            guide['image'],
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          guide['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4,
                          ),
                          child: Text(
                            guide['desc'],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "\$${guide['price']}",
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
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
                            ),
                            child: const Text("Book Now"),
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
