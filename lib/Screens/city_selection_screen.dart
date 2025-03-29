import 'package:flutter/material.dart';

class SelectCityScreen extends StatelessWidget {
  final String selectedCountry;

  SelectCityScreen({required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    print("SelectCityScreen loaded with country: $selectedCountry"); // Debug log

    return Scaffold(
      appBar: AppBar(
        title: Text('Cities in $selectedCountry'),
      ),
      body: Center(
        child: Text('Display cities for $selectedCountry here'),
      ),
    );
  }
}
