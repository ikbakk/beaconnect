class UpdateStory {
  const UpdateStory({
    required this.timeGroup,
    required this.title,
    required this.story,
    required this.place,
    this.type = 'default',
    this.timeLabel = '',
  });

  final String timeGroup;
  final String title;
  final String story;
  final String place;
  
  /// Update type for icon selection: 'checkin', 'arrival', 'departure', 'live', 'reaction', 'default'
  final String type;
  
  /// Formatted time label: "8:23 AM", "Yesterday 9:02 PM"
  final String timeLabel;

  Map<String, Object?> toJson() {
    return {
      'timeGroup': timeGroup,
      'title': title,
      'story': story,
      'place': place,
      'type': type,
      'timeLabel': timeLabel,
    };
  }

  factory UpdateStory.fromJson(Map<String, dynamic> json) {
    return UpdateStory(
      timeGroup: json['timeGroup'] as String,
      title: json['title'] as String,
      story: json['story'] as String,
      place: json['place'] as String,
      type: json['type'] as String? ?? 'default',
      timeLabel: json['timeLabel'] as String? ?? '',
    );
  }
}
