import 'package:flutter/material.dart';

class SelectCityScreen extends StatelessWidget {
  final String selectedCountry; // Named parameter

  // Constructor to accept the selectedCountry parameter
  const SelectCityScreen({Key? key, required this.selectedCountry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example list of cities (you can replace it with your actual list of cities)
    final List<String> cities = [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'San Antonio',
      'San Diego',
      'Dallas',
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Select City")),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              // When a city is selected, return the selected city to the previous screen
              Navigator.pop(context, cities[index]);
            },
          );
        },
      ),
    );
  }
}
