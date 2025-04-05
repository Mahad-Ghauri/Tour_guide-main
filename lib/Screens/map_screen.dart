// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:tour_guide_application/Controllers/city_controller.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _mapController;
//   LatLng _selectedLocation = LatLng(
//     37.7749,
//     -122.4194,
//   ); // Default location (San Francisco)
//   TextEditingController _cityNameController = TextEditingController();
//   TextEditingController _countryCodeController = TextEditingController(
//     text: 'US',
//   );

//   @override
//   void dispose() {
//     _cityNameController.dispose();
//     _countryCodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Select a City')),
//       body: Column(
//         children: [
//           Expanded(
//             child: GoogleMap(
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _selectedLocation,
//                 zoom: 10,
//               ),
//               onTap: (LatLng location) {
//                 setState(() {
//                   _selectedLocation = location;
//                 });
//               },
//               markers: {
//                 Marker(
//                   markerId: MarkerId('selected-location'),
//                   position: _selectedLocation,
//                 ),
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _cityNameController,
//                   decoration: InputDecoration(
//                     labelText: 'City Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 TextField(
//                   controller: _countryCodeController,
//                   decoration: InputDecoration(
//                     labelText: 'Country Code',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (_cityNameController.text.isEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Please enter a city name')),
//             );
//             return;
//           }

//           // Create a city object
//           final selectedCity = {
//             'name': _cityNameController.text,
//             'country': _countryCodeController.text,
//             'location': _selectedLocation,
//           };

//           final cityController = Provider.of<CityController>(
//             context,
//             listen: false,
//           );

//           // Use the corrected method call
//           if (await cityController.saveCityToSupabase(selectedCity)) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('City saved successfully!')),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Failed to save city')),
//             );
//           }
//         },
//         child: const Icon(Icons.save),
//       ),
//     );
//   }
// }
