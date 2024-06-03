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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCwM3H60288vwrAKgVg_mH1CZKXZyOsca8',
    appId: '1:819104125483:web:9bc38529b60d649806506e',
    messagingSenderId: '819104125483',
    projectId: 'solar-tracker-4bdc7',
    authDomain: 'solar-tracker-4bdc7.firebaseapp.com',
    storageBucket: 'solar-tracker-4bdc7.appspot.com',
    measurementId: 'G-E6B3DFS8GC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA45qrjF-nGcuFGb_oGD8e-NIyA6Itk254',
    appId: '1:819104125483:android:6b1dd818157c3f8806506e',
    messagingSenderId: '819104125483',
    projectId: 'solar-tracker-4bdc7',
    storageBucket: 'solar-tracker-4bdc7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAISKq8Zi-RRSaSxc_Rr8ipLWKgVXOGgrk',
    appId: '1:819104125483:ios:140268598734e71706506e',
    messagingSenderId: '819104125483',
    projectId: 'solar-tracker-4bdc7',
    storageBucket: 'solar-tracker-4bdc7.appspot.com',
    iosBundleId: 'com.example.solarTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAISKq8Zi-RRSaSxc_Rr8ipLWKgVXOGgrk',
    appId: '1:819104125483:ios:140268598734e71706506e',
    messagingSenderId: '819104125483',
    projectId: 'solar-tracker-4bdc7',
    storageBucket: 'solar-tracker-4bdc7.appspot.com',
    iosBundleId: 'com.example.solarTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCwM3H60288vwrAKgVg_mH1CZKXZyOsca8',
    appId: '1:819104125483:web:6f6b53783c6d221806506e',
    messagingSenderId: '819104125483',
    projectId: 'solar-tracker-4bdc7',
    authDomain: 'solar-tracker-4bdc7.firebaseapp.com',
    storageBucket: 'solar-tracker-4bdc7.appspot.com',
    measurementId: 'G-MDLYVHY686',
  );
}
