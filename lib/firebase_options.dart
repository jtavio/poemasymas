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
    apiKey: 'AIzaSyCYUx5C5tisF61P4h5F3tmmcAvKDXz7WfA',
    appId: '1:153536167266:web:d7517139b635b765ce003b',
    messagingSenderId: '153536167266',
    projectId: 'poemasymas-469bd',
    authDomain: 'poemasymas-469bd.firebaseapp.com',
    storageBucket: 'poemasymas-469bd.appspot.com',
    measurementId: 'G-EMLFJ884K3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwYWh7iBf9WiZZWPM5WLvy1rfKxIry5Jg',
    appId: '1:153536167266:android:57dec288a593a50cce003b',
    messagingSenderId: '153536167266',
    projectId: 'poemasymas-469bd',
    storageBucket: 'poemasymas-469bd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyP7mCaI6YQolvCEFwGic3i_KyKwZMCDU',
    appId: '1:153536167266:ios:f00006f1458e8ed2ce003b',
    messagingSenderId: '153536167266',
    projectId: 'poemasymas-469bd',
    storageBucket: 'poemasymas-469bd.appspot.com',
    iosClientId: '153536167266-nduuvtttn4aecgnufcs2m3pvahjsne46.apps.googleusercontent.com',
    iosBundleId: 'com.example.appPoemas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyP7mCaI6YQolvCEFwGic3i_KyKwZMCDU',
    appId: '1:153536167266:ios:f00006f1458e8ed2ce003b',
    messagingSenderId: '153536167266',
    projectId: 'poemasymas-469bd',
    storageBucket: 'poemasymas-469bd.appspot.com',
    iosClientId: '153536167266-nduuvtttn4aecgnufcs2m3pvahjsne46.apps.googleusercontent.com',
    iosBundleId: 'com.example.appPoemas',
  );
}