class UpdateStory {
  const UpdateStory({
    required this.timeGroup,
    required this.title,
    required this.story,
    required this.place,
  });

  final String timeGroup;
  final String title;
  final String story;
  final String place;

  Map<String, Object?> toJson() {
    return {
      'timeGroup': timeGroup,
      'title': title,
      'story': story,
      'place': place,
    };
  }

  factory UpdateStory.fromJson(Map<String, dynamic> json) {
    return UpdateStory(
      timeGroup: json['timeGroup'] as String,
      title: json['title'] as String,
      story: json['story'] as String,
      place: json['place'] as String,
    );
  }
}
