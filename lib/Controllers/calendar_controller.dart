import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:tour_guide_application/services/supabase_service.dart';

class CalendarController {
  final SupabaseClient _supabase = SupabaseService().supabase;

  Future<void> createEvent(CalendarEvent event) async {
    try {
      await _supabase.from('calendar_events').insert({
        'title': event.title,
        'date': event.date.toIso8601String(),
        'description': event.description,
        'is_festival': event.isFestival ? 1 : 0,
      });
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }

  Future<void> updateEvent(CalendarEvent event) async {
    try {
      await _supabase
          .from('calendar_events')
          .update(event.toMap())
          .eq('id', event.id);
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    }
  }

  Future<List<CalendarEvent>> getEventsForMonth(DateTime month) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 1);

      final response = await _supabase
          .from('calendar_events')
          .select()
          .gte('date', startDate.toIso8601String())
          .lt('date', endDate.toIso8601String())
          .order('date', ascending: true);

      if (response.isEmpty) {
        print("No events found for the selected month.");
        return [];
      }

      return response.map((data) => CalendarEvent.fromJson(data)).toList();
    } catch (e) {
      print('Error getting events: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _supabase.from('calendar_events').delete().eq('id', id);
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }
}
