class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'latitude': latitude, 'longitude': longitude};
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
