// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0RcIpSUf4ZpaVpSZTdP0HQj6xHu-GE9U',
    appId: '1:370662930446:web:5da117a5063cb49442245f',
    messagingSenderId: '370662930446',
    projectId: 'calpal-3bfaf',
    authDomain: 'calpal-3bfaf.firebaseapp.com',
    storageBucket: 'calpal-3bfaf.appspot.com',
    measurementId: 'G-4ZJBK233EJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDUrGXDn4IaGhTKFielntB2YTYT5MPwnqk',
    appId: '1:370662930446:android:e7efcc40a849335342245f',
    messagingSenderId: '370662930446',
    projectId: 'calpal-3bfaf',
    storageBucket: 'calpal-3bfaf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7PpkYRX_VqNRacrQd_BymwiN3uPuEBRw',
    appId: '1:370662930446:ios:3e0674cf878a28ca42245f',
    messagingSenderId: '370662930446',
    projectId: 'calpal-3bfaf',
    storageBucket: 'calpal-3bfaf.appspot.com',
    iosBundleId: 'com.example.calpal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7PpkYRX_VqNRacrQd_BymwiN3uPuEBRw',
    appId: '1:370662930446:ios:ba2d0c079837924c42245f',
    messagingSenderId: '370662930446',
    projectId: 'calpal-3bfaf',
    storageBucket: 'calpal-3bfaf.appspot.com',
    iosBundleId: 'com.example.calpal.RunnerTests',
  );
}
