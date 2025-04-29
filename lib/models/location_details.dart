import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationDetails {
  final LatLng location;
  final String name;
  final String description;

  LocationDetails({
    required this.location,
    required this.name,
    required this.description,
  });
}
