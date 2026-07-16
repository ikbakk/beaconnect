class PartnerSummary {
  const PartnerSummary({
    required this.name,
    required this.statusSentence,
    required this.freshnessSentence,
    this.pairSymbol = '★',
    this.badgeLabel,
    this.badgeVariant = 'default',
  });

  /// Partner display name only — e.g. "Sarah". The pair symbol is rendered
  /// alongside the name in the UI, but is not part of the display name.
  final String name;
  final String statusSentence;
  final String freshnessSentence;

  /// The pair symbol shown next to the partner's name. Owned by the partner
  /// (configurable in My Beacon). Rendered by the partner card, not the
  /// repository.
  final String pairSymbol;

  /// Optional badge label (e.g., "Live", "Paused")
  final String? badgeLabel;

  /// Badge variant: 'live', 'paused', 'info', 'success', 'default'
  final String badgeVariant;
}
