import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/models/calendar_event.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar'), elevation: 0),
      body:
          calendarController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
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
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      calendarController.focusDate(focusedDay);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selected Date: ${calendarController.selectedDate.toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(child: _buildEventsList(calendarController.events)),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context, calendarController),
        child: const Icon(Icons.add),
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
          subtitle: Text(event.description),
          trailing:
              event.isFestival
                  ? const Icon(Icons.celebration, color: Colors.amber)
                  : null,
          onTap: () => _showEventDetails(context, event),
        );
      },
    );
  }

  void _showAddEventDialog(
    BuildContext context,
    CalendarController controller,
  ) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isFestival = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Event'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('Is Festival'),
                        value: isFestival,
                        onChanged: (value) {
                          setState(() {
                            isFestival = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final event = CalendarEvent(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          description: descriptionController.text,
                          date: controller.selectedDate,
                          isFestival: isFestival,
                        );
                        controller.createEvent(event);
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          ),
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
                Text('Date: ${event.date.toString().split(' ')[0]}'),
                const SizedBox(height: 8),
                Text('Description: ${event.description}'),
                if (event.isFestival) ...[
                  const SizedBox(height: 8),
                  const Text('🎉 Festival Event'),
                ],
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
