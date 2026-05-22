class LiveSharingSession {
  const LiveSharingSession({
    required this.id,
    required this.minutesRemaining,
    required this.reason,
    required this.isPaused,
  });

  final String id;
  final int minutesRemaining;
  final String? reason;
  final bool isPaused;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'minutesRemaining': minutesRemaining,
      'reason': reason,
      'isPaused': isPaused,
    };
  }

  factory LiveSharingSession.fromJson(Map<String, dynamic> json) {
    return LiveSharingSession(
      id: json['id'] as String,
      minutesRemaining: json['minutesRemaining'] as int,
      reason: json['reason'] as String?,
      isPaused: json['isPaused'] as bool? ?? false,
    );
  }
}
