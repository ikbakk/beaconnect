class PlaceSnapshot {
  const PlaceSnapshot({
    required this.placeLabel,
    required this.capturedAt,
  });

  final String placeLabel;
  final DateTime capturedAt;

  Map<String, Object?> toJson() {
    return {
      'placeLabel': placeLabel,
      'capturedAt': capturedAt.toIso8601String(),
    };
  }

  factory PlaceSnapshot.fromJson(Map<String, dynamic> json) {
    return PlaceSnapshot(
      placeLabel: json['placeLabel'] as String,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
    );
  }
}
