import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class CityController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Change type to List<Map<String, dynamic>> to match the API response
  List<Map<String, dynamic>> _cities = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get cities => _cities;
  bool get isLoading => _isLoading;

  // Fetch cities based on the selected country ID from GeoDB Cities API and store them in Supabase
  Future<void> fetchCitiesAndStoreInSupabase(String countryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://wft-geo-db.p.rapidapi.com/v1/geo/cities?countryIds=$countryId',
        ),
        headers: {
          'x-rapidapi-key':
              '8103e93284msh611565a6202e093p16a4c9jsn413cbdab7a45',
          'x-rapidapi-host': 'wft-geo-db.p.rapidapi.com',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (!data.containsKey('data')) {
          throw Exception("Unexpected API response format. Check API docs.");
        }

        List<Map<String, dynamic>> citiesData = List<Map<String, dynamic>>.from(
          data['data'],
        );

        if (citiesData.isEmpty) {
          throw Exception("No cities found for country ID: $countryId");
        }

        // Clear old data
        await _supabase.from('cities').delete().eq('country_id', countryId);

        // Insert new data
        for (var city in citiesData) {
          await _supabase.from('cities').insert({
            'country_id': countryId,
            'name': city['name'] ?? 'Unknown',
            'description':
                city.containsKey('description')
                    ? city['description']
                    : 'No description',
          });
        }

        _cities = citiesData;

        print("✅ Fetched and stored cities for country: $countryId");
      } else {
        throw Exception("Failed to load cities: ${response.body}");
      }
    } catch (e) {
      print("❌ Error fetching and storing cities: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
