import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleMapService {
  static const apiKey = "AIzaSyAeaU65bPgJ0XnoQy1Js9gmwxG_ixb_f0w";
  static final tts = FlutterTts();

  static Future<LatLng> getCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    return LatLng(pos.latitude, pos.longitude);
  }

  static Future<Map<String, dynamic>> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    List steps = data['routes'][0]['legs'][0]['steps'];
    List<LatLng> polylinePoints = [];

    for (var step in steps) {
      final endLoc = step['end_location'];
      polylinePoints.add(LatLng(endLoc['lat'], endLoc['lng']));
    }

    return {
      'steps': steps.map((s) => s['html_instructions'].toString()).toList(),
      'polylines': {
        Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: polylinePoints,
        ),
      },
      'markers': {
        Marker(
            markerId: MarkerId("destination"),
            position: destination,
            infoWindow: InfoWindow(title: "Destination"))
      }
    };
  }

  static Future<void> startVoiceNavigation(List steps) async {
    for (var step in steps) {
      await tts.speak(step.replaceAll(RegExp(r'<[^>]*>'), '')); // remove HTML tags
      await Future.delayed(Duration(seconds: 3));
    }
  }
}
