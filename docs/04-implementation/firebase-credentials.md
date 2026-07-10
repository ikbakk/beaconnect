# Firebase Credentials Setup

## Status

- `lib/firebase_options.dart` — real Android values, projectId/storageBucket shared across all platforms
- `android/app/google-services.json` — real config in place (gitignored)

Non-Android platform app IDs still use placeholders (only Android is fully configured).

## Where real files live

### Android

```text
android/app/google-services.json  (gitignored)
```

A placeholder example exists at:

```text
android/app/google-services.json.example
```

### FlutterFire options

```text
lib/firebase_options.dart
```

The Android block is real. Non-Android blocks (iOS, web, macOS, windows, linux) have real `projectId`, `storageBucket`, and `messagingSenderId` but placeholder `apiKey` and `appId` until those apps are created in Firebase console.

## Recommended command

To add more platforms, run FlutterFire CLI for this app package:

```text
com.beaconnect.beaconnect
```

Then replace the placeholder blocks in `lib/firebase_options.dart`.

## Important

Do not keep placeholder values in production builds.
