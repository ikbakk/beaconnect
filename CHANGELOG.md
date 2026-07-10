# Changelog

## 0.2.0 — 2026-07-10

### What's New
- Added Crashlytics integration for crash reporting.
- Real Firebase project wired (beaconnect-8b8c8).
- Android home-screen widget with partner status at a glance.

### Improvements
- Home screen, check-in, trust center, and live sharing now include screen-reader labels.
- Reduced motion respected for accessibility.
- Calmer empty and error states across Updates, My Beacon, and Trust Center.
- CI workflow now runs analyze, test, and release APK build on push.

### Fixes
- Sign in and sign up are now explicit flows with clear error messaging.
- Pairing lifecycle tightened: one-time codes expire, self-use rejected, pending invites reused.
- Check-in no longer shows success until confirmed delivery.
- Home no longer invents placeholder updates in a fresh state.
- Firebase updates now use the real signed-in user ID.
- Firestore rules locked down for users, events, live sessions, devices.
- Release signing config placeholder noted (still debug for now).

### Notes for Testers
- Crashlytics will report crashes in production builds.
- App Distribution setup still pending in Firebase console.
- Invite codes expire server-side only when Cloud Functions are deployed.

### Known Issues
- Only Android Firebase config is real; iOS and web still use placeholder app IDs.
- No geolocator integration yet — place snapshots use manual labels.
- Golden tests not yet added.

## 0.1.0 — 2026-07-10

### What's New
- Added clear sign in and sign up flows for onboarding.
- Added mutual pairing flow with calmer invite handling.
- Added manual current-place updates and live sharing lifecycle support.

### Improvements
- Home now reflects real paired state, recent updates, and current-place freshness more honestly.
- Check-ins now wait for confirmed delivery before showing success.
- Trust Center, My Beacon, and Updates now include calmer empty and recovery states.

### Fixes
- Tightened Firestore access rules for users, events, live sessions, and devices.
- Replaced placeholder Firebase actor ids in updates with the signed-in user.
- Prevented local mock data from inventing updates in a fresh home state.

### Notes for Testers
- Pairing codes are short-lived and one-time use.
- Live Sharing can now be paused, resumed, and ended.
- The Android release checks workflow builds a release APK in CI.

### Known Issues
- Release signing still needs production credentials.
- Crashlytics and App Distribution still require Firebase project setup.
