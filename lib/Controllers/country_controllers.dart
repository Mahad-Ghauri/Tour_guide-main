import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountryController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, String>> _countries = [];
  bool _isLoading = false;

  List<Map<String, String>> get countries => _countries;
  bool get isLoading => _isLoading;

  /// Fetch all countries from API and store them in Supabase
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
            'flag': country['flags']['png'],
          };
        }).toList();

        _countries.sort((a, b) => a['name']!.compareTo(b['name']!));
        await storeCountriesInSupabase();
      } else {
        throw Exception("Failed to load countries");
      }
    } catch (e) {
      print("❌ Error fetching countries: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Store fetched countries in Supabase
  Future<void> storeCountriesInSupabase() async {
    try {
      await _supabase.from('countries').delete().neq('name', ''); // Ensures no empty country names are stored.
      for (var country in _countries) {
        await _supabase.from('countries').insert({
          'name': country['name'],
          'flag': country['flag'],
        });
      }
      print("✅ Countries stored in Supabase");
    } catch (e) {
      print("❌ Error storing countries in Supabase: $e");
    }
  }
Future<void> saveSelectedCountry(String countryName) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    try {
      final response = await _supabase.from('selected_country').upsert({
        'name': countryName, // Use 'name' instead of 'country_name'
        'user_id': user.id,
      });

      if (response.error != null) {
        print('❌ Error saving selected country: ${response.error?.message}');
      } else {
        print('✅ Selected country saved successfully');
      }
    } catch (e) {
      print("❌ Error saving selected country: $e");
    }
  } else {
    print('❌ User is not authenticated');
  }
}


 Future<void> fetchSelectedCountry() async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print("❌ User not authenticated");
      return;
    }

    final response = await _supabase
        .from('selected_country')
        .select()
        .eq('user_id', user.id)
        .maybeSingle(); // Returns null if no record found

    if (response != null) {
      print("🔹 Previously Selected Country: ${response['name']}"); // Use 'name' here
    } else {
      print("ℹ No country selected yet.");
    }
  } catch (e) {
    print("❌ Error fetching selected country: $e");
  }
}

}
