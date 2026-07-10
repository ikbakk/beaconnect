class LiveSharingSession {
  const LiveSharingSession({
    required this.id,
    required this.minutesRemaining,
    required this.reason,
    required this.isPaused,
    required this.startedAt,
    required this.endsAt,
    this.pausedAt,
  });

  final String id;
  final int minutesRemaining;
  final String? reason;
  final bool isPaused;
  final DateTime startedAt;
  final DateTime endsAt;
  final DateTime? pausedAt;

  bool get isExpired => !isPaused && endsAt.isBefore(DateTime.now());

  LiveSharingSession copyWith({
    int? minutesRemaining,
    String? reason,
    bool? isPaused,
    DateTime? startedAt,
    DateTime? endsAt,
    DateTime? pausedAt,
    bool clearPausedAt = false,
  }) {
    return LiveSharingSession(
      id: id,
      minutesRemaining: minutesRemaining ?? this.minutesRemaining,
      reason: reason ?? this.reason,
      isPaused: isPaused ?? this.isPaused,
      startedAt: startedAt ?? this.startedAt,
      endsAt: endsAt ?? this.endsAt,
      pausedAt: clearPausedAt ? null : pausedAt ?? this.pausedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'minutesRemaining': minutesRemaining,
      'reason': reason,
      'isPaused': isPaused,
      'startedAt': startedAt.toIso8601String(),
      'endsAt': endsAt.toIso8601String(),
      'pausedAt': pausedAt?.toIso8601String(),
    };
  }

  factory LiveSharingSession.fromJson(Map<String, dynamic> json) {
    final startedAt = DateTime.tryParse(json['startedAt'] as String? ?? '');
    final endsAt = DateTime.tryParse(json['endsAt'] as String? ?? '');
    final pausedAt = DateTime.tryParse(json['pausedAt'] as String? ?? '');
    final minutesRemaining = json['minutesRemaining'] as int? ?? 0;

    return LiveSharingSession(
      id: json['id'] as String,
      minutesRemaining: minutesRemaining,
      reason: json['reason'] as String?,
      isPaused: json['isPaused'] as bool? ?? false,
      startedAt: startedAt ?? DateTime.now(),
      endsAt: endsAt ?? DateTime.now().add(Duration(minutes: minutesRemaining)),
      pausedAt: pausedAt,
    );
  }
}
