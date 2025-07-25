// destination_data.dart
class DestinationInfo {
  final String placeId;
  final String placeName;
  final List<String> pictures;
  final String history;
  final List<String> foodRecommendations;

  DestinationInfo({
    required this.placeId,
    required this.placeName,
    required this.pictures,
    required this.history,
    required this.foodRecommendations,
  });

  Map<String, dynamic> toMap() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'pictures': pictures,
      'history': history,
      'food_recommendations': foodRecommendations,
    };
  }

  factory DestinationInfo.fromMap(Map<String, dynamic> map) {
    return DestinationInfo(
      placeId: map['place_id'],
      placeName: map['place_name'],
      pictures: List<String>.from(map['pictures']),
      history: map['history'],
      foodRecommendations: List<String>.from(map['food_recommendations']),
    );
  }
}
