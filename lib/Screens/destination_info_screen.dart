import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/data/destination_data.dart';

class DestinationInfoScreen extends StatefulWidget {
  final String placeId;

  const DestinationInfoScreen({required this.placeId});

  @override
  _DestinationInfoScreenState createState() => _DestinationInfoScreenState();
}

class _DestinationInfoScreenState extends State<DestinationInfoScreen> {
  DestinationInfo? info;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchDestinationInfo();
  }

  Future<void> _fetchDestinationInfo() async {
    try {
      final response = await Supabase.instance.client
          .from('destinations')
          .select()
          .eq('place_id', widget.placeId)
          .single();
      setState(() {
        info = DestinationInfo(
          placeId: response['place_id'],
          placeName: response['place_name'],
          pictures: List<String>.from(response['pictures']),
          history: response['history'],
          foodRecommendations: List<String>.from(response['food_recommendations']),
        );
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load destination: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text(error!)),
      );
    }

    if (info == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(info!.placeName)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pictures
            Text('Pictures', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: info!.pictures.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.network(
                      info!.pictures[index],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 100),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // History
            Text('History', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            Text(info!.history),
            SizedBox(height: 20),
            // Food Recommendations
            Text('Food Recommendations', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            ...info!.foodRecommendations.map((food) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('• $food'),
                )),
          ],
        ),
      ),
    );
  }
}