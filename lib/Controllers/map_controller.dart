import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_guide_application/Services/location_service.dart';
import 'package:tour_guide_application/Screens/location_entry_screen.dart';
import 'package:tour_guide_application/models/location_details.dart';

class MapController extends ChangeNotifier {
  // public state:
  LatLng center = const LatLng(30.1575, 71.5249);
  Marker? selectedMarker;
  bool permissionDenied = false;

  late GoogleMapController mapController;

  MapController() {
    _requestLocationPermission();
  }

  /// Hook this up to your GoogleMap.onMapCreated
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Call this from initState
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      await _moveToUserLocation();
    } else {
      permissionDenied = true;
      notifyListeners();
    }
  }

  Future<void> _moveToUserLocation() async {
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    center = LatLng(pos.latitude, pos.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(center));
    notifyListeners();
  }

  /// Hook to GoogleMap.onTap
  void pickLocation(LatLng loc) {
    selectedMarker = Marker(
      markerId: const MarkerId('picked'),
      position: loc,
      infoWindow: const InfoWindow(title: 'Selected Location'),
    );
    notifyListeners();
  }

  /// Call from your FAB
  Future<void> goToEntryAndSave(BuildContext context) async {
    if (selectedMarker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tap map first')),
      );
      return;
    }

    // Navigate to entry screen and await details
    final details = await Navigator.push<LocationDetails>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationEntryScreen(
          pickedLocation: selectedMarker!.position,
        ),
      ),
    );

    if (details != null) {
      // Save via service
      final success = await LocationService.save(details);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Location saved!'
              : 'Failed to save: check your backend'),
        ),
      );
    }
  }
}
