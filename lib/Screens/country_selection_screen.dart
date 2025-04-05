import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CountryController>(context, listen: false).fetchCountries();
    });
  }

  void _filterCountries(String query, List<Map<String, String>> countries) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = countries;
      } else {
        filteredCountries =
            countries
                .where(
                  (country) => country['name']!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final countryController = Provider.of<CountryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Country"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Country",
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged:
                  (query) =>
                      _filterCountries(query, countryController.countries),
            ),
          ),
          Expanded(
            child:
                countryController.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3,
                        ),
                        itemCount:
                            searchController.text.isEmpty
                                ? countryController.countries.length
                                : filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country =
                              searchController.text.isEmpty
                                  ? countryController.countries[index]
                                  : filteredCountries[index];

                          return GestureDetector(
                            onTap: () async {
                              // ✅ Save selected country using both name and ISO code
                              await Provider.of<CountryController>(
                                context,
                                listen: false,
                              ).saveSelectedCountry(
                                country['name']!,
                                country['code']!,
                              );

                              // ✅ Navigate and pass ISO country code to CitySelectionScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CitySelectionScreen(
                                        countryId:
                                            country['code']!, // Pass country code here
                                      ),
                                ),
                              );
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
                              child: Row(
                                children: [
                                  Image.network(
                                    country['flag']!,
                                    width: 30,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      country['name']!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
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
