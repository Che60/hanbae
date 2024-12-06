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
    apiKey: 'AIzaSyBVKcL3P2t_q6_Vs9lDTCtQLV8NFl1sU0k',
    appId: '1:225405021397:web:fbb97c2f66c673c1f5865c',
    messagingSenderId: '225405021397',
    projectId: 'hanbae-83c30',
    authDomain: 'hanbae-83c30.firebaseapp.com',
    storageBucket: 'hanbae-83c30.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9evIxXyBSqz07tFb5W9Gq1gN31z2fA1I',
    appId: '1:225405021397:android:bc9faa0914d66361f5865c',
    messagingSenderId: '225405021397',
    projectId: 'hanbae-83c30',
    storageBucket: 'hanbae-83c30.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeL12Bo7DCVF-4s-EofWOOVaB3LzfnvtY',
    appId: '1:225405021397:ios:0ca24e2f2c4b0ceff5865c',
    messagingSenderId: '225405021397',
    projectId: 'hanbae-83c30',
    storageBucket: 'hanbae-83c30.firebasestorage.app',
    iosBundleId: 'com.example.hanbae',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeL12Bo7DCVF-4s-EofWOOVaB3LzfnvtY',
    appId: '1:225405021397:ios:0ca24e2f2c4b0ceff5865c',
    messagingSenderId: '225405021397',
    projectId: 'hanbae-83c30',
    storageBucket: 'hanbae-83c30.firebasestorage.app',
    iosBundleId: 'com.example.hanbae',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBVKcL3P2t_q6_Vs9lDTCtQLV8NFl1sU0k',
    appId: '1:225405021397:web:0d544467740ae924f5865c',
    messagingSenderId: '225405021397',
    projectId: 'hanbae-83c30',
    authDomain: 'hanbae-83c30.firebaseapp.com',
    storageBucket: 'hanbae-83c30.firebasestorage.app',
  );
}
