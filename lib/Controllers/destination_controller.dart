// controllers/destination_controller.dart
// ignore_for_file: unnecessary_null_comparison

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/destination_model.dart';


class DestinationController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveDestination(DestinationInfo info) async {
    final response = await supabase.from('destinations').insert(info.toMap());

    if (response == null) {
      throw Exception('Failed to insert destination');
    }
  }

  Future<DestinationInfo?> getDestinationById(String placeId) async {
    final response = await supabase
        .from('destinations')
        .select()
        .eq('place_id', placeId)
        .single();

    if (response == null) return null;

    return DestinationInfo.fromMap(response);
  }

  Future<List<DestinationInfo>> getAllDestinations() async {
    final response = await supabase.from('destinations').select();

    return (response as List)
        .map((data) => DestinationInfo.fromMap(data))
        .toList();
  }
}
