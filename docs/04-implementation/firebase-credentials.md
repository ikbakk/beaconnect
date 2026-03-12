# Firebase Credentials Setup

This project currently includes **placeholders only**.

## Put real Firebase files here

### Android

Save the real Firebase Android config as:

```text
android/app/google-services.json
```

A placeholder example exists at:

```text
android/app/google-services.json.example
```

### FlutterFire options

Generate and save FlutterFire options as:

```text
lib/firebase_options.dart
```

The current `lib/firebase_options.dart` is a placeholder scaffold and should be replaced.

## Recommended command later

After creating the Firebase project and Android app, run FlutterFire CLI and generate real options for this app package:

```text
com.beaconnect.beaconnect
```

Then replace:

- `lib/firebase_options.dart`
- `android/app/google-services.json`

## Current Firebase mode toggle

Run with:

```bash
flutter run --dart-define=USE_FIREBASE=true
```

## Important

Do not keep placeholder values in production builds.
