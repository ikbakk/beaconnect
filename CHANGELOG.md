# Changelog

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
