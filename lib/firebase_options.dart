// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyArx9kEVjH9PEt0mumN8n3DOIyAKp5I770',
    appId: '1:1054386875264:web:2e6dbbeb8a25018adaaf65',
    messagingSenderId: '1054386875264',
    projectId: 'healthmetrictracker',
    authDomain: 'healthmetrictracker.firebaseapp.com',
    storageBucket: 'healthmetrictracker.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTYFQ-ttNkdQ-jguxlVknPNg6JS2ehb4I',
    appId: '1:1054386875264:android:69671f82703fcf37daaf65',
    messagingSenderId: '1054386875264',
    projectId: 'healthmetrictracker',
    storageBucket: 'healthmetrictracker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBU3lYx1gB7K-qGuaKozXU013QmUMtCkHs',
    appId: '1:1054386875264:ios:ccdd8506e580eb2fdaaf65',
    messagingSenderId: '1054386875264',
    projectId: 'healthmetrictracker',
    storageBucket: 'healthmetrictracker.firebasestorage.app',
    iosBundleId: 'com.example.healthMetricsTracker',
  );

}