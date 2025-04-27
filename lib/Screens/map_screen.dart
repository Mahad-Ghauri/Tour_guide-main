import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_guide_application/controllers/map_controller.dart';
import 'package:tour_guide_application/Screens/location_entry_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  // Function to request location permission
  Future<void> _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // Optionally handle the case where the user denies the permission
      // Example: Show a message or redirect to settings
    }
  }

  @override
  Widget build(BuildContext context) {
    // Request permission for location access
    _requestPermission();

    return ChangeNotifierProvider(
      create: (_) => MapController(),
      child: Consumer<MapController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Explore Map'),
            ),
            body: GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.center,
                zoom: 14.0,
              ),
              markers: controller.selectedMarker != null
                  ? {controller.selectedMarker!}
                  : {},
              onTap: controller.pickLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            floatingActionButton: controller.selectedMarker != null
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      // Navigate to LocationEntryScreen with the pickedLocation
                      final result = await Navigator.push<LatLng>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocationEntryScreen(
                            pickedLocation: controller.selectedMarker!.position,
                          ),
                        ),
                      );

                      // You can handle the result here if needed (e.g. saving the location)
                    },
                    label: const Text('Select Location'),
                    icon: const Icon(Icons.location_on),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  )
                : Container(), // Only show button when a location is selected
          );
        },
      ),
    );
  }
}
