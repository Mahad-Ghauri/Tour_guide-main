import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/destination_reached_screen.dart';

class MapScreen extends StatefulWidget {
  final String placeName;
  final LatLng destination;

  const MapScreen({required this.placeName, required this.destination});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  LatLng? _currentLocation;
  final FlutterTts tts = FlutterTts();
  bool _hasReachedDestination = false;
  Timer? _locationCheckTimer;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Start periodic location check
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkDestinationProximity();
    });
  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _saveLocationToSupabase(LatLng location) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('User not authenticated');
        return;
      }

      await _supabase.from('user_locations').insert({
        'user_id': userId,
        'place_name': widget.placeName,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'visited_at': DateTime.now().toIso8601String(),
      });

      print('Location saved to Supabase successfully');
    } catch (e) {
      print('Error saving location to Supabase: $e');
    }
  }

  Future<void> _checkDestinationProximity() async {
    if (_currentLocation == null || _hasReachedDestination) return;

    final distance = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      widget.destination.latitude,
      widget.destination.longitude,
    );

    // If within 50 meters of destination
    if (distance <= 50) {
      _hasReachedDestination = true;
      _locationCheckTimer?.cancel();
      
      // Save the reached destination to Supabase
      await _saveLocationToSupabase(widget.destination);
      
      // Stop TTS if speaking
      await tts.stop();
      
      if (mounted) {
        // Show destination reached screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationReachedScreen(
              placeName: widget.placeName,
            ),
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _getRoute();
  }

  Future<void> _getRoute() async {
    final origin = '${_currentLocation!.latitude},${_currentLocation!.longitude}';
    final destination = '${widget.destination.latitude},${widget.destination.longitude}';
    final apiKey = 'AIzaSyAeaU65bPgJ0XnoQy1Js9gmwxG_ixb_f0w';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final points = data['routes'][0]['overview_polyline']['points'];
      _routePoints = _decodePolyline(points);

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: _routePoints,
        ));
      });

      // Voice instruction
      String summary = data['routes'][0]['legs'][0]['steps']
          .map<String>((step) => step['html_instructions'])
          .join(', ')
          .replaceAll(RegExp(r'<[^>]*>'), '');

      await tts.speak("Starting navigation to ${widget.placeName}. $summary");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigation to ${widget.placeName}')),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _currentLocation!, zoom: 14),
              onMapCreated: (controller) => mapController = controller,
              markers: {
                Marker(markerId: MarkerId('start'), position: _currentLocation!),
                Marker(markerId: MarkerId('end'), position: widget.destination),
              },
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
