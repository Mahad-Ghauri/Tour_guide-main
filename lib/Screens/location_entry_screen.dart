import 'package:flutter/material.dart';

class LocationEntryScreen extends StatelessWidget {
  final String selectedCity;
  
  LocationEntryScreen({required this.selectedCity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Location")),
      body: Center(child: Text("Selected City: $selectedCity")),
    );
  }
}
