// lib/Controllers/location_controller.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_guide_application/models/location_details.dart';

class LocationEntryController {
  final LatLng pickedLocation;
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  LocationEntryController(this.pickedLocation);

  void dispose() { /* ... */ }

  LocationDetails? confirm(BuildContext context) {
    // ...
    return LocationDetails(
      location: pickedLocation,
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
    );
  }
}
