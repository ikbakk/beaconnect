class PermissionStatus {
  const PermissionStatus({
    required this.locationSharingEnabled,
    required this.notificationsEnabled,
  });

  final bool locationSharingEnabled;
  final bool notificationsEnabled;

  bool get isReadyForSharing =>
      locationSharingEnabled && notificationsEnabled;

  PermissionStatus copyWith({
    bool? locationSharingEnabled,
    bool? notificationsEnabled,
  }) {
    return PermissionStatus(
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
