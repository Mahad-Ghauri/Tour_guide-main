class PlaceDetails {
  final String id;
  final String name;
  final String history;
  final List<String> imageUrls;
  final List<String> foodRecommendations;

  PlaceDetails({
    required this.id,
    required this.name,
    required this.history,
    required this.imageUrls,
    required this.foodRecommendations,
  });

  factory PlaceDetails.fromMap(Map<String, dynamic> map) {
    return PlaceDetails(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      history: map['history'] ?? '',
      imageUrls: List<String>.from(map['image_urls'] ?? []),
      foodRecommendations: List<String>.from(map['food_recommendations'] ?? []),
    );
  }
}
