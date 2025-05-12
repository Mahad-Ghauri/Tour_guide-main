// controllers/destination_controller.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/data/destination_data.dart';


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
