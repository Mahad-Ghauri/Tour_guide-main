import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';
import 'location_entry_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _showBottomSheet = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Permission.location.request();

    if (permission.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
          _addMarker(LatLng(position.latitude, position.longitude), 'Home');
        });

        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(position.latitude, position.longitude),
              14.0,
            ),
          );
        }
      } catch (e) {
        print("Error getting location: $e");
      }
    }
  }

  void _addMarker(LatLng position, String markerId) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14.0,
        ),
      );
    }
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  _currentPosition != null
                      ? LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      )
                      : const LatLng(30.181459, 71.492157), // Default to Multan
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
          ),

          // Search bar
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationEntryScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Search here',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(Icons.mic, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ),

          // Category buttons
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton(Icons.restaurant, 'Restaurants'),
                _buildCategoryButton(Icons.shopping_bag, 'Apparel'),
                _buildCategoryButton(Icons.shopping_cart, 'Shopping'),
              ],
            ),
          ),

          // Map controls
          Positioned(
            bottom: _showBottomSheet ? 130 : 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'layers',
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.layers, color: Colors.black54),
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'location',
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                  onPressed: _getCurrentLocation,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'directions',
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.directions),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Bottom Sheet (Colony name and temperature)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gulgasht Colony',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.nights_stay, color: Colors.blue),
                              SizedBox(width: 5),
                              Text('36°', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomNavButton(Icons.explore, 'Explore', true),
                      _buildBottomNavButton(
                        Icons.bookmark_border,
                        'You',
                        false,
                      ),
                      _buildBottomNavButton(
                        Icons.add_circle_outline,
                        'Contribute',
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
