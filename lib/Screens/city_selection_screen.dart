import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';

class CitySelectionScreen extends StatefulWidget {
  final String countryId; // Country ID passed from CountrySelectionScreen

  const CitySelectionScreen({super.key, required this.countryId});

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCities = [];

  @override
  void initState() {
    super.initState();
    // Fetch cities for the selected country when the screen is loaded
    Future.microtask(() {
      Provider.of<CityController>(
        context,
        listen: false,
      ).fetchCitiesAndStoreInSupabase(widget.countryId);
    });
  }

  void _filterCities(String query, List<Map<String, dynamic>> cities) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = cities;
      } else {
        filteredCities =
            cities
                .where(
                  (city) =>
                      city['name']!.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityController = Provider.of<CityController>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Select City'), backgroundColor: Colors.teal),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search City",
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) => _filterCities(query, cityController.cities),
            ),
          ),
          // City List/Grid
          Expanded(
            child:
                cityController.isLoading
                    ? Center(
                      child: CircularProgressIndicator(),
                    ) // Loading indicator
                    : Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount:
                            searchController.text.isEmpty
                                ? cityController.cities.length
                                : filteredCities.length,
                        itemBuilder: (context, index) {
                          final city =
                              searchController.text.isEmpty
                                  ? cityController.cities[index]
                                  : filteredCities[index];

                          return GestureDetector(
                            onTap: () {
                              // Handle city selection
                              print('Selected City: ${city['name']}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.teal,
                                  ), // City icon
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      city['name']!, // Here we assume `city['name']` is a String
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
