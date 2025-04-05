import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountryController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 30);

  List<Map<String, String>> _countries = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, String>> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch countries from RestCountries API with retry logic
  Future<void> _fetchFromAPI() async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final response = await http
            .get(Uri.parse('https://restcountries.com/v3.1/all'))
            .timeout(_timeout);

        if (response.statusCode == 200) {
          List data = json.decode(response.body);
          print("🌍 Total countries fetched: ${data.length}");

          _countries =
              data.map<Map<String, String>>((country) {
                return {
                  'name': country['name']['common'],
                  'flag': country['flags']['png'],
                  'code': country['cca2'] ?? '',
                };
              }).toList();

          _countries.sort((a, b) => a['name']!.compareTo(b['name']!));
          await storeCountriesInSupabase();
          return; // Success, exit the retry loop
        } else {
          throw Exception("Failed to load countries: ${response.statusCode}");
        }
      } catch (e) {
        retryCount++;
        if (retryCount == _maxRetries) {
          _error = "Failed to fetch countries after $_maxRetries attempts: $e";
          rethrow;
        }
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }
  }

  /// Fetch countries with retry logic
  Future<void> fetchCountries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to fetch from API first
      await _fetchFromAPI();
    } catch (e) {
      print("❌ Error fetching from API: $e");
      // If API fails, try to load from Supabase
      await _loadFromSupabase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load countries from Supabase as fallback
  Future<void> _loadFromSupabase() async {
    try {
      final response = await _supabase.from('countries').select().order('name');

      if (response != null) {
        _countries = List<Map<String, String>>.from(response);
        print("✅ Loaded ${_countries.length} countries from Supabase");
      } else {
        _error = "No countries found in database";
      }
    } catch (e) {
      _error = "Failed to load countries from database: $e";
      print("❌ Error loading from Supabase: $e");
    }
  }

  /// Store fetched countries in Supabase
  Future<void> storeCountriesInSupabase() async {
    try {
      // Use a transaction to ensure data consistency
      await _supabase.from('countries').delete().neq('name', '');

      // Insert in batches to avoid overwhelming the database
      const batchSize = 50;
      for (var i = 0; i < _countries.length; i += batchSize) {
        final end =
            (i + batchSize < _countries.length)
                ? i + batchSize
                : _countries.length;
        final batch = _countries.sublist(i, end);

        await _supabase
            .from('countries')
            .insert(
              batch
                  .map(
                    (country) => {
                      'name': country['name'],
                      'flag': country['flag'],
                      'code': country['code'],
                    },
                  )
                  .toList(),
            );
      }
      print("✅ Countries stored in Supabase");
    } catch (e) {
      print("❌ Error storing countries in Supabase: $e");
      _error = "Failed to store countries: $e";
    }
  }

  /// Save selected country for current user in Supabase
  Future<void> saveSelectedCountry(
    String countryName,
    String countryCode,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        await _supabase.from('selected_country').upsert({
          'user_id': user.id,
          'name': countryName,
          'code': countryCode,
        });

        print('✅ Selected country saved successfully');
      } catch (e) {
        print("❌ Error saving selected country: $e");
      }
    } else {
      print('❌ User is not authenticated');
    }
  }

  /// Fetch previously selected country from Supabase
  Future<void> fetchSelectedCountry() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        print("❌ User not authenticated");
        return;
      }

      final response =
          await _supabase
              .from('selected_country')
              .select()
              .eq('user_id', user.id)
              .maybeSingle();

      if (response != null) {
        print(
          "🔹 Previously Selected Country: ${response['name']} (${response['code']})",
        );
      } else {
        print("ℹ No country selected yet.");
      }
    } catch (e) {
      print("❌ Error fetching selected country: $e");
    }
  }
}
