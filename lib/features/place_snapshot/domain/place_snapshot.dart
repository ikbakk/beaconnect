class PlaceSnapshot {
  const PlaceSnapshot({
    required this.placeLabel,
    required this.capturedAt,
    this.latitude,
    this.longitude,
  });

  final String placeLabel;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates => latitude != null && longitude != null;

  Map<String, Object?> toJson() {
    return {
      'placeLabel': placeLabel,
      'capturedAt': capturedAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PlaceSnapshot.fromJson(Map<String, dynamic> json) {
    return PlaceSnapshot(
      placeLabel: json['placeLabel'] as String,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
