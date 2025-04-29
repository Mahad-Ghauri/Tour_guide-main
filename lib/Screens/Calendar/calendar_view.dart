import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_guide_application/controllers/calendar_controller.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatelessWidget {
  static const String id = 'CalendarView';
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarController(),
      child: const CalendarScreenContent(),
    );
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
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: calendarController.isLoading
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
                  eventLoader: (day) {
                    return calendarController.events
                        .where((event) => isSameDay(event.date, day))
                        .toList();
                  },
                  onFormatChanged: (format) {
                    setState(() => _calendarFormat = format);
                  },
                  onPageChanged: (focusedDay) {
                    calendarController.focusDate(focusedDay);
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.teal[300],
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Selected Date: ${DateFormat.yMMMMd().format(calendarController.selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: _buildEventsList(calendarController),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventsList(CalendarController calendarController) {
    final events = calendarController.events
        .where((event) => 
            event.date.year == calendarController.selectedDate.year &&
            event.date.month == calendarController.selectedDate.month &&
            event.date.day == calendarController.selectedDate.day)
        .toList();
    
    if (events.isEmpty) {
      return const Center(child: Text('No events for this date'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Text(DateFormat.Hm().format(event.date)),
          onTap: () => _showEventDialog(context, event),
        );
      },
    );
  }

void _showAddEventDialog(BuildContext context) {
  final titleController = TextEditingController();
  // Store the CalendarController before showing the dialog
  final calendarController = Provider.of<CalendarController>(context, listen: false);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Add Event'),
      content: TextField(
        controller: titleController,
        decoration: const InputDecoration(labelText: 'Event Title'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              // Use the stored controller instead of trying to get it from the dialog context
              calendarController.createEvent(titleController.text);
              Navigator.pop(dialogContext);
            }
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}

void _showEventDialog(BuildContext context, CalendarEvent event) {
  // Store the CalendarController before showing the dialog
  final calendarController = Provider.of<CalendarController>(context, listen: false);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
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
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            // Use the stored controller instead of trying to get it from the dialog context
            calendarController.deleteEvent(event.id);
            Navigator.pop(dialogContext);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
}