class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'].toString(),
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }
}