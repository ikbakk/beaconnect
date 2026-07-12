class PartnerSummary {
  const PartnerSummary({
    required this.name,
    required this.statusSentence,
    required this.freshnessSentence,
    this.badgeLabel,
    this.badgeVariant = 'default',
  });

  final String name;
  final String statusSentence;
  final String freshnessSentence;

  /// Optional badge label (e.g., "Live", "Paused")
  final String? badgeLabel;

  /// Badge variant: 'live', 'paused', 'info', 'success', 'default'
  final String badgeVariant;
}
