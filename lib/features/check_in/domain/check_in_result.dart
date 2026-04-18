class CheckInResult {
  const CheckInResult({
    required this.wasSent,
    required this.enteredCooldown,
  });

  final bool wasSent;
  final bool enteredCooldown;
}
