class NotificationPayload {
  const NotificationPayload({
    required this.title,
    required this.body,
    required this.type,
    this.pairId,
  });

  final String title;
  final String body;
  final String type;
  final String? pairId;

  factory NotificationPayload.fromRemoteMessage({
    required String? title,
    required String? body,
    required Map<String, dynamic> data,
  }) {
    return NotificationPayload(
      title: title ?? 'Beaconnect',
      body: body ?? 'You have a new update.',
      type: data['type'] as String? ?? 'unknown',
      pairId: data['pairId'] as String?,
    );
  }
}
