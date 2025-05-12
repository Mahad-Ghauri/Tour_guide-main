// screens/destination_info_screen.dart
import 'package:flutter/material.dart';
import '../controllers/destination_controller.dart';
import 'package:tour_guide_application/data/destination_data.dart';


class DestinationInfoScreen extends StatefulWidget {
  final String placeId;

  const DestinationInfoScreen({super.key, required this.placeId});

  @override
  State<DestinationInfoScreen> createState() => _DestinationInfoScreenState();
}

class _DestinationInfoScreenState extends State<DestinationInfoScreen> {
  late DestinationController _controller;
  DestinationInfo? _destinationInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = DestinationController();
    _loadDestination();
  }

  Future<void> _loadDestination() async {
    try {
      final info = await _controller.getDestinationById(widget.placeId);
      setState(() {
        _destinationInfo = info;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error loading destination: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_destinationInfo == null) {
      return const Center(child: Text("Destination not found."));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_destinationInfo!.placeName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("History", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(_destinationInfo!.history),
            const SizedBox(height: 16),
            Text("Recommended Foods", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._destinationInfo!.foodRecommendations
                .map((food) => Text("- $food")),
            const SizedBox(height: 16),
            Text("Gallery", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _destinationInfo!.pictures.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(_destinationInfo!.pictures[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
