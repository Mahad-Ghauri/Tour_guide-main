import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationEntryScreen extends StatefulWidget {
  final LatLng pickedLocation;

  const LocationEntryScreen({Key? key, required this.pickedLocation})
      : super(key: key);

  @override
  _LocationEntryScreenState createState() => _LocationEntryScreenState();
}

class _LocationEntryScreenState extends State<LocationEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Marker> _markers = [];
  final String googleApiKey = 'AIzaSyAeaU65bPgJ0XnoQy1Js9gmwxG_ixb_f0w';

  @override
  void initState() {
    super.initState();
    _getNearbyPlaces(widget.pickedLocation);
  }

  // Fetch nearby places
  Future<void> _getNearbyPlaces(LatLng pickedLocation) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${pickedLocation.latitude},${pickedLocation.longitude}&radius=1000&type=restaurant&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _markers.clear();
          for (var place in data['results']) {
            final LatLng placeLocation = LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            );
            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: placeLocation,
                infoWindow: InfoWindow(title: place['name']),
              ),
            );
          }
        });
      } else {
        throw Exception('Failed to load nearby places');
      }
    } catch (e) {
      // Handle errors (e.g., network issues or API key issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading nearby places: $e')),
      );
    }
  }

  // Validate inputs
  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  // Save location and navigate back
  void _saveLocationAndViewMap() {
    if (_validateInputs()) {
      final locationDetails = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'latitude': widget.pickedLocation.latitude,
        'longitude': widget.pickedLocation.longitude,
      };
      Navigator.pop(context, locationDetails);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Build AppBar with teal background
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Location Entry'),
      backgroundColor: Colors.teal,
      elevation: 4,
    );
  }

  // Build the main body
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationHeader(),
            const SizedBox(height: 20),
            _buildLocationNameField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildSaveButton(),
            const SizedBox(height: 20),
            _buildMapView(),
          ],
        ),
      ),
    );
  }

  // Build the location header
  Widget _buildLocationHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Location:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Lat: ${widget.pickedLocation.latitude}, Lng: ${widget.pickedLocation.longitude}',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  // Build the location name input field
  Widget _buildLocationNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Location Name',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  // Build the description input field
  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: 4,
    );
  }

  // Build the save button
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveLocationAndViewMap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Save Location & View on Map',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Build the Google Map view
  Widget _buildMapView() {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.pickedLocation,
          zoom: 14.0,
        ),
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {},
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}