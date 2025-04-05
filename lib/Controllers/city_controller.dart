import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class CityController extends ChangeNotifier {
  // Supabase client
  final _supabase = Supabase.instance.client;

  // Cities data
  List<Map<String, dynamic>> _cities = [];
  Map<String, dynamic>? _selectedCity;
  bool _isLoading = false;

  // Google Maps data
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _mapCenter = const LatLng(
    37.42796133580664,
    -122.085749655962,
  ); // Default center
  double _zoomLevel = 5.0;

  // Getters
  List<Map<String, dynamic>> get cities => _cities;
  Map<String, dynamic>? get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  GoogleMapController? get mapController => _mapController;
  Set<Marker> get markers => _markers;
  LatLng get mapCenter => _mapCenter;
  double get zoomLevel => _zoomLevel;

  // Initialize controller and load cities
  Future<void> initialize() async {
    await loadCities();
  }

  // Set map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedCity != null) {
      moveToSelectedCity();
    }
    notifyListeners();
  }

  // ✅ Load all cities
  Future<void> loadCities() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('cities')
          .select(
            'id, name, country, latitude, longitude, population, description',
          )
          .order('name');

      _cities = List<Map<String, dynamic>>.from(data);
      _updateCityMarkers();
    } catch (e) {
      debugPrint('Error loading cities: $e');
      _cities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Load cities by country ID
  Future<void> loadCitiesByCountryId(String countryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('cities')
          .select(
            'id, name, country, latitude, longitude, population, description',
          )
          .eq('country', countryId)
          .order('name');

      _cities = List<Map<String, dynamic>>.from(data);
      _updateCityMarkers();
    } catch (e) {
      debugPrint('Error loading cities by country ID: $e');
      _cities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Search cities by name
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    if (query.isEmpty) return _cities;

    try {
      final data = await _supabase
          .from('cities')
          .select('id, name, country, latitude, longitude')
          .ilike('name', '%$query%')
          .order('name')
          .limit(10);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error searching cities: $e');
      return [];
    }
  }

  // ✅ Add a new city
  Future<bool> addCity(Map<String, dynamic> cityData) async {
    try {
      await _supabase.from('cities').insert(cityData);
      await loadCities();
      return true;
    } catch (e) {
      print('Error adding city: $e');
      return false;
    }
  }

  // ✅ Save city (used by admin)
  Future<bool> saveCityToSupabase(Map<String, dynamic> city) async {
    try {
      await _supabase.from('cities').insert({
        'name': city['name'],
        'country': city['country'],
        'latitude': city['latitude'],
        'longitude': city['longitude'],
        'population': city['population'],
        'description': city['description'],
      });

      await loadCities();
      return true;
    } catch (e) {
      print('Exception saving city: $e');
      return false;
    }
  }

  // ✅ Select a city
  void selectCity(Map<String, dynamic> city) {
    _selectedCity = city;
    moveToSelectedCity();
    notifyListeners();
  }

  // ✅ Clear selection
  void clearSelection() {
    _selectedCity = null;
    notifyListeners();
  }

  // ✅ Move map to selected city
  void moveToSelectedCity() {
    if (_selectedCity != null && _mapController != null) {
      final lat = _selectedCity!['latitude'] as double;
      final lng = _selectedCity!['longitude'] as double;
      final newPosition = LatLng(lat, lng);

      _mapCenter = newPosition;
      _zoomLevel = 12.0;

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: _zoomLevel),
        ),
      );

      notifyListeners();
    }
  }

  // ✅ Update city markers
  void _updateCityMarkers() {
    _markers = {};

    for (final city in _cities) {
      final markerId = MarkerId(city['id'].toString());
      final marker = Marker(
        markerId: markerId,
        position: LatLng(
          city['latitude'] as double,
          city['longitude'] as double,
        ),
        infoWindow: InfoWindow(title: city['name'], snippet: city['country']),
        onTap: () {
          selectCity(city);
        },
      );

      _markers.add(marker);
    }

    notifyListeners();
  }

  // ✅ Update map manually
  void updateMapPosition(LatLng position, double zoom) {
    _mapCenter = position;
    _zoomLevel = zoom;

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );

    notifyListeners();
  }
}
