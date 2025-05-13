// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class CityController {
  final SupabaseClient _client = Supabase.instance.client;

  /// Store the selected city name in the Supabase `cities` table
  Future<void> storeCityInSupabase(String cityName) async {
    try {
      final response = await _client.from('cities').insert({
        'name': cityName,
      });

      print("City '$cityName' inserted successfully: $response");
    } catch (e) {
      print("Error inserting city '$cityName': $e");
    }
  }
}
