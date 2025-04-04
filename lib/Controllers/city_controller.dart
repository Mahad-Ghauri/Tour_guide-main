import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class CityController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _cities = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get cities => _cities;
  bool get isLoading => _isLoading;

  /// Fetch cities based on the selected country code from GeoDB and store them in Supabase
  Future<void> fetchCitiesAndStoreInSupabase(String countryCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url =
          'https://wft-geo-db.p.rapidapi.com/v1/geo/cities?countryIds=$countryCode&limit=10';

      print("📦 API URL: $url");

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'x-rapidapi-key':
                  '8103e93284msh611565a6202e093p16a4c9jsn413cbdab7a45',
              'x-rapidapi-host': 'wft-geo-db.p.rapidapi.com',
            },
          )
          .timeout(Duration(seconds: 10));

      print("📥 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (!data.containsKey('data')) {
          throw Exception(
            "Unexpected API response format: missing 'data' key.",
          );
        }

        List<Map<String, dynamic>> citiesData = List<Map<String, dynamic>>.from(
          data['data'],
        );

        if (citiesData.isEmpty) {
          throw Exception("No cities found for country code: $countryCode");
        }

        // Optional: Clear old cities for this country
        await _supabase.from('cities').delete().eq('country_id', countryCode);

        // Insert new data
        for (var city in citiesData) {
          try {
            await _supabase.from('cities').insert({
              'country_id': countryCode,
              'name': city['name'] ?? 'Unknown',
              'description': city['region'] ?? 'No description',
              // Optionally add: 'city_image': your_image_url_logic,
            });
          } catch (e) {
            print("❌ Error inserting city: ${city['name']}, $e");
          }
        }

        _cities = citiesData;

        print(
          "✅ Successfully fetched and stored ${citiesData.length} cities for: $countryCode",
        );
      } else {
        print("❌ API failed with status: ${response.statusCode}");
        print("🔻 Response Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Error in fetchCitiesAndStoreInSupabase: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
