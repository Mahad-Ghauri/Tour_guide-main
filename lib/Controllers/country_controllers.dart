import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryController extends ChangeNotifier {
  List<Map<String, String>> _countries = [];
  bool _isLoading = false;

  List<Map<String, String>> get countries => _countries;
  bool get isLoading => _isLoading;

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        _countries = data.map<Map<String, String>>((country) {
          return {
            'name': country['name']['common'],
            'flag': country['flags']['png'], // Get the PNG flag
          };
        }).toList();

        _countries.sort((a, b) => a['name']!.compareTo(b['name']!)); // Sort Alphabetically
      } else {
        throw Exception("Failed to load countries");
      }
    } catch (e) {
      print("Error fetching countries: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
