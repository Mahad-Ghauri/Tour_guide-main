import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GoogleMapController {
  GoogleMapController();

  Set<Marker> markers = {};

  // This method adds a marker to the map based on the selected location
  void addMarker(LatLng position, String markerId) {
    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: markerId),
      ),
    );
  }

  // Add navigation logic here if needed for directions
}
