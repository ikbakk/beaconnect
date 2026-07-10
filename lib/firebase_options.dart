import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options generated from the real google-services.json.
/// See android/app/google-services.json for the source of truth.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'placeholder-web-api-key',
    appId: '1:000000000000:web:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    authDomain: 'beaconnect-placeholder.firebaseapp.com',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP7cW8tRtJAAFpFT7RR6ByLDIqI0Au_0w',
    appId: '1:225817273796:android:a5a72e3a9c3eaba8b03091',
    messagingSenderId: '225817273796',
    projectId: 'beaconnect-8b8c8',
    storageBucket: 'beaconnect-8b8c8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'placeholder-ios-api-key',
    appId: '1:000000000000:ios:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
    iosBundleId: 'com.beaconnect.beaconnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'placeholder-macos-api-key',
    appId: '1:000000000000:macos:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
    iosBundleId: 'com.beaconnect.beaconnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'placeholder-windows-api-key',
    appId: '1:000000000000:windows:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'placeholder-linux-api-key',
    appId: '1:000000000000:linux:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
  );
}
