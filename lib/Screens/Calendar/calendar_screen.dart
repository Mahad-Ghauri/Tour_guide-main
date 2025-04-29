import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  void showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Event'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final calendarController = Provider.of<CalendarController>(
                      context,
                      listen: false,
                    );
                    calendarController.createEvent(titleController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CalendarScreenContent();
  }
}

class CalendarScreenContent extends StatefulWidget {
  const CalendarScreenContent({super.key});

  @override
  State<CalendarScreenContent> createState() => _CalendarScreenContentState();
}

class _CalendarScreenContentState extends State<CalendarScreenContent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final calendarController = Provider.of<CalendarController>(context);

    return SafeArea(
      child:
          calendarController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Calendar',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: calendarController.focusedDate,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(calendarController.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      calendarController.selectDate(selectedDay);
                      calendarController.focusDate(focusedDay);
                    },
                    onFormatChanged: (format) {
                      setState(() => _calendarFormat = format);
                    },
                    onPageChanged: (focusedDay) {
                      calendarController.focusDate(focusedDay);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selected Date: ${DateFormat.yMMMMd().format(calendarController.selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(child: _buildEventsList(calendarController.events)),
                ],
              ),
    );
  }

  Widget _buildEventsList(List<CalendarEvent> events) {
    if (events.isEmpty) {
      return const Center(child: Text('No events for this date'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.title),
          onTap: () => _showEventDetails(context, event),
        );
      },
    );
  }

  void _showEventDetails(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(event.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${DateFormat.yMMMMd().format(event.date)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
