import 'package:flutter/material.dart';
import 'place_data.dart';

class QrDetailsScreen extends StatelessWidget {
  final PlaceDetails placeDetails;

  const QrDetailsScreen({Key? key, required this.placeDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(placeDetails.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("History", style: Theme.of(context).textTheme.headline6),
          Text(placeDetails.history),
          const SizedBox(height: 16),
          Text("Images", style: Theme.of(context).textTheme.headline6),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: placeDetails.imageUrls
                  .map((url) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(url),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text("Food Recommendations", style: Theme.of(context).textTheme.headline6),
          ...placeDetails.foodRecommendations
              .map((food) => ListTile(title: Text(food))),
        ],
      ),
    );
  }
}
