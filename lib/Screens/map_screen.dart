// import 'package:http/http.dart' as http;
// import 'dart:convert' show jsonDecode;
// ignore_for_file: unused_field, deprecated_member_use, use_build_context_synchronously, avoid_print, sort_child_properties_last

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/destination_reached_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String placeName;
  final LatLng destination;

  const MapScreen({super.key, required this.placeName, required this.destination});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late GoogleMapController mapController;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routePoints = [];
  LatLng? _currentLocation;
  final FlutterTts tts = FlutterTts();
  bool _hasReachedDestination = false;
  Timer? _locationCheckTimer;
  final _supabase = Supabase.instance.client;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _configureTts();
    _startLocationUpdates();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      _showDestinationConfirmationDialog();
    }
  }

  Future<void> _showDestinationConfirmationDialog() async {
    if (_hasReachedDestination) return;

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Destination Reached?'),
          content: Text('Have you reached ${widget.placeName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _handleDestinationReached();
    }
  }

  void _startLocationUpdates() {
    // Check location every 3 seconds
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_hasReachedDestination) {
        timer.cancel();
        return;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
        );

        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });

        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          widget.destination.latitude,
          widget.destination.longitude,
        );

        if (distance <= 50) {
          _hasReachedDestination = true;
          timer.cancel();
          await _handleDestinationReached();
        }
      } catch (e) {
        print('Error checking location: $e');
      }
    });
  }

  Future<void> _handleDestinationReached() async {
    try {
      // Save to Supabase
      await _saveLocationToSupabase(widget.destination);
      
      // Stop TTS
      await tts.stop();

      // Show destination reached screen
      if (mounted) {
        // Use a short delay to ensure smooth transition
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Navigate using pushAndRemoveUntil to clear the navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DestinationReachedScreen(
              placeName: widget.placeName,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error handling destination reached: $e');
    }
  }

  Future<void> _configureTts() async {
    await tts.setLanguage('en-US');
    await tts.setVolume(1.0);
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1.0);
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

  Future<void> _launchMapsApp() async {
    if (_currentLocation == null) return;

    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${widget.destination.latitude},${widget.destination.longitude}&travelmode=walking';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    tts.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasReachedDestination) {
          // If destination is reached, prevent going back
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Map Navigation'),
          automaticallyImplyLeading: !_hasReachedDestination,
          backgroundColor: const Color(0xFF559CB2),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: _currentLocation == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
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
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: _launchMapsApp,
                      child: const Icon(Icons.navigation),
                      tooltip: 'Open in Maps',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}