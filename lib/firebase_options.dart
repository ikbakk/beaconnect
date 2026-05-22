import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Placeholder Firebase options for local development scaffolding.
/// Replace these values with FlutterFire-generated values later.
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
    apiKey: 'placeholder-android-api-key',
    appId: '1:000000000000:android:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'beaconnect-placeholder',
    storageBucket: 'beaconnect-placeholder.firebasestorage.app',
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
