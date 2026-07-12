# State Management — Beaconnect Flutter

**Source:** `design/prototype/beaconnect-app.html` (all JS state logic)

---

## Overview

Use **Riverpod** for all state. Domain layer is Flutter-free — it must not import Firebase or platform APIs.

```
lib/
  domain/           ← pure Dart, no Flutter, no Firebase
    models/
    services/
  data/             ← Firebase / platform adapters
  providers/        ← Riverpod providers (Flutter, but domain-free)
  ui/
```

---

## Core app states

All states are defined in `domain/models/app_state.dart`.

### Partner Card states

```dart
enum PartnerCardState {
  normal,            // "Everything looks normal."
  live,              // "Sharing live." + duration timer
  paused,            // "Sharing is currently paused."
  noUpdates,         // "No new updates yet."
  permissionMissing, // "Sharing is not fully available yet."
  noPartner,         // "Welcome. Pair with someone to get started."
  connectionEnded,   // "This shared connection has ended."
}
```

**Every state preserves the same layout.** Only copy changes. Users don't relearn the interface.

---

### Okay button states

```dart
enum OkayButtonState {
  idle,      // "I'm Okay"
  sending,   // "Sending…" (brief, ~1s)
  success,   // "Done" (reverts to idle after 1s)
  cooldown,  // "You recently checked in." (no tap action)
}
```

---

### Live sharing state

```dart
enum LiveSharingState {
  off,
  starting,
  active,
  stopping,
}
```

---

## Providers

### Partner card provider

```dart
@riverpod
class PartnerCardNotifier extends _$PartnerCardNotifier {
  @override
  PartnerCardState build() => PartnerCardState.normal;

  void setState(PartnerCardState state) => _state = state;

  // Called when Firebase emits a partner status change
  void onPartnerStatusChanged(PartnerStatus status) {
    switch (status.kind) {
      case PartnerStatusKind.normal  => setState(PartnerCardState.normal);
      case PartnerStatusKind.live   => setState(PartnerCardState.live);
      case PartnerStatusKind.paused => setState(PartnerCardState.paused);
      case PartnerStatusKind.noUpdates => setState(PartnerCardState.noUpdates);
    }
  }
}
```

---

### Live sharing provider

```dart
@riverpod
class LiveSharingNotifier extends _$LiveSharingNotifier {
  @override
  LiveSharingState build() => LiveSharingState.off;

  Future<void> startLive() async {
    _state = LiveSharingState.starting;
    // Firebase: write live session start
    await _partnerRepository.startLiveSharing();
    _state = LiveSharingState.active;
  }

  Future<void> stopLive() async {
    _state = LiveSharingState.stopping;
    await _partnerRepository.stopLiveSharing();
    _state = LiveSharingState.off;
  }

  Duration get elapsed {
    if (_liveStartTime == null) return Duration.zero;
    return DateTime.now().difference(_liveStartTime!);
  }
}
```

---

### Okay button provider

```dart
@riverpod
class OkayButtonNotifier extends _$OkayButtonNotifier {
  @override
  OkayButtonState build() => OkayButtonState.idle;

  Future<void> sendOkay() async {
    if (_state == OkayButtonState.cooldown) return;
    _state = OkayButtonState.sending;
    await _checkInRepository.sendCheckIn();
    _state = OkayButtonState.success;
    // Haptic feedback here
    await Future.delayed(const Duration(seconds: 1));
    _state = OkayButtonState.cooldown;
    await Future.delayed(const Duration(minutes: 3));
    _state = OkayButtonState.idle;
  }
}
```

---

### Permission state provider

```dart
@riverpod
class PermissionNotifier extends _$PermissionNotifier {
  @override
  PermissionState build() => PermissionState.loading;

  Future<void> checkPermissions() async {
    // Platform channel: check location + notification + battery opt-in
    final status = await _permissionService.checkAll();
    if (status.backgroundLocation && status.notifications && status.battery) {
      _state = PermissionState.granted;
    } else {
      _state = PermissionState.partial;
    }
  }
}
```

---

## State persistence

```dart
// Domain service: SharedPreferences-backed state
abstract class AppSettings {
  bool get quietHoursEnabled;
  Duration get quietHoursStart;
  Duration get quietHoursEnd;
  List<String> get checkInMessages;  // custom message pool
  String get pairSymbol;
}
```

---

## Navigation state

```dart
enum NavDestination { home, updates, settings }

@riverpod
class NavNotifier extends _$NavNotifier {
  @override
  NavDestination build() => NavDestination.home;

  void navigateTo(NavDestination dest) => _state = dest;
}
```

---

## Loading state rule

> Show last known state first. No spinner.

```dart
@override
Widget build(BuildContext context) {
  final status = ref.watch(partnerStatusStreamProvider);

  // Always show the Partner Card — even before first load
  return status.when(
    data:    (s) => PartnerCard(state: s.cardState, ...),
    loading: () => PartnerCard(state: _lastKnownState, ...),  // last known state
    error:   (_, __) => PartnerCard(state: PartnerCardState.normal, ...),
  );
}
```

---

## State that doesn't belong in UI

Keep in domain (Flutter-free):

- Firestore document structure
- Background task scheduling
- Battery optimization intent handling
- Notification payload parsing
- Geofence trigger logic

Keep in providers (Flutter-aware):

- Widget rebuild triggers
- GoRouter navigation
- Haptic feedback
- Permission request calls
