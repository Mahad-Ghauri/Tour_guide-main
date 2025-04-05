import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';

// CitySelectionScreen that accepts country_id
class CitySelectionScreen extends StatefulWidget {
  final String countryId; // Accept country_id

  const CitySelectionScreen({Key? key, required this.countryId})
    : super(key: key);

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    // Initialize the city controller when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cityController = Provider.of<CityController>(
        context,
        listen: false,
      );
      cityController.loadCitiesByCountryId(
        widget.countryId,
      ); // Pass country_id to load cities
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Handle search input changes
  void _onSearchChanged(String query, CityController controller) async {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      final results = await controller.searchCities(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'City Explorer',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CityController>(
        builder: (context, cityController, child) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a city...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => _onSearchChanged(value, cityController),
                ),
              ),

              // Selected city information
              if (cityController.selectedCity != null)
                _buildSelectedCityCard(cityController),

              // Map and city list view
              Expanded(
                child: Row(
                  children: [
                    // City list (left side)
                    Expanded(
                      flex: 2,
                      child:
                          _isSearching
                              ? _buildSearchResults(cityController)
                              : _buildCityList(cityController),
                    ),

                    // Map view (right side)
                    Expanded(flex: 3, child: _buildMapView(cityController)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Selected city information card
  Widget _buildSelectedCityCard(CityController controller) {
    final city = controller.selectedCity!;
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  city['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.clearSelection(),
                ),
              ],
            ),
            Text(
              city['country'],
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            if (city['population'] != null)
              Text(
                'Population: ${(city['population'] as int).toStringAsFixed(0)}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            if (city['description'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  city['description'],
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // City list view
  Widget _buildCityList(CityController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.cities.isEmpty) {
      return Center(
        child: Text('No cities found', style: GoogleFonts.poppins()),
      );
    }

    return ListView.builder(
      itemCount: controller.cities.length,
      itemBuilder: (context, index) {
        final city = controller.cities[index];
        final isSelected =
            controller.selectedCity != null &&
            controller.selectedCity!['id'] == city['id'];

        return ListTile(
          title: Text(
            city['name'],
            style: GoogleFonts.poppins(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            city['country'],
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          selected: isSelected,
          selectedTileColor: Colors.blue[50],
          onTap: () => controller.selectCity(city),
          leading: Icon(
            Icons.location_city,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        );
      },
    );
  }

  // Search results list
  Widget _buildSearchResults(CityController controller) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No cities match your search',
          style: GoogleFonts.poppins(),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final city = _searchResults[index];
        return ListTile(
          title: Text(city['name'], style: GoogleFonts.poppins()),
          subtitle: Text(
            city['country'],
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          onTap: () {
            controller.selectCity(city);
            // Clear search
            _searchController.clear();
            setState(() {
              _isSearching = false;
              _searchResults = [];
            });
          },
          leading: const Icon(Icons.location_city),
        );
      },
    );
  }

  // Map view
  Widget _buildMapView(CityController controller) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.mapCenter,
              zoom: controller.zoomLevel,
            ),
            onMapCreated: (GoogleMapController mapController) {
              controller.setMapController(mapController);
            },
            markers: controller.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: _currentMapType, // Use the state variable here
            zoomControlsEnabled: true,
          ),
          if (controller.isLoading)
            const Center(child: CircularProgressIndicator()),
          // Map type selector button
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'mapType',
              child: const Icon(Icons.layers),
              onPressed: () {
                _showMapTypeSelector(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show map type selection bottom sheet
  void _showMapTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Normal', style: GoogleFonts.poppins()),
                leading: const Icon(Icons.map),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.normal;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Satellite', style: GoogleFonts.poppins()),
                leading: const Icon(Icons.satellite),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.satellite;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Terrain', style: GoogleFonts.poppins()),
                leading: const Icon(Icons.terrain),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.terrain;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Hybrid', style: GoogleFonts.poppins()),
                leading: const Icon(Icons.satellite_alt),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.hybrid;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
