// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// //import 'package:permission_handler/permission_handler.dart';
// import 'package:tour_guide_application/controllers/map_controller.dart';
// import 'package:tour_guide_application/Screens/location_entry_screen.dart';
// import 'package:provider/provider.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   // Function to request location permission
//   Future<void> _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isDenied) {
//       // Optionally handle the case where the user denies the permission
//       // Example: Show a message or redirect to settings
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Request permission for location access
//     _requestPermission();

//     return ChangeNotifierProvider(
//       create: (_) => MapController(),
//       child: Consumer<MapController>(
//         builder: (context, controller, child) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Explore Map'),
//             ),
//             body: GoogleMap(
//               onMapCreated: controller.onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: controller.center,
//                 zoom: 14.0,
//               ),
//               markers: controller.selectedMarker != null
//                   ? {controller.selectedMarker!}
//                   : {},
//               onTap: controller.pickLocation,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//             floatingActionButton: controller.selectedMarker != null
//                 ? FloatingActionButton.extended(
//                     onPressed: () async {
//                       // Navigate to LocationEntryScreen with the pickedLocation
//                       final result = await Navigator.push<LatLng>(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => LocationEntryScreen(
//                             pickedLocation: controller.selectedMarker!.position,
//                           ),
//                         ),
//                       );

//                       // You can handle the result here if needed (e.g. saving the location)
//                     },
//                     label: const Text('Select Location'),
//                     icon: const Icon(Icons.location_on),
//                     backgroundColor: Colors.teal,
//                     foregroundColor: Colors.white,
//                   )
//                 : Container(), // Only show button when a location is selected
//           );
//         },
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
          ? Center(child: CircularProgressIndicator())
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
            ),
    );
  }
}
