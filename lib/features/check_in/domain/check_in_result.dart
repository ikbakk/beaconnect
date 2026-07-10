class CheckInResult {
  const CheckInResult({
    required this.wasSent,
    required this.enteredCooldown,
    required this.message,
  });

  final bool wasSent;
  final bool enteredCooldown;
  final String message;
}
