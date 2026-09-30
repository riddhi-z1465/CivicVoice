import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Configured for CivicVoice (civicvoice-c476a).
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
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLalEWIJFdMPV6UMJR23ski4VDf_i6BQY',
    appId: '1:875064076699:web:6a5ead04331b0a9bd5d93e',
    messagingSenderId: '875064076699',
    projectId: 'civicvoice-c476a',
    authDomain: 'civicvoice-c476a.firebaseapp.com',
    storageBucket: 'civicvoice-c476a.firebasestorage.app',
    measurementId: 'G-7ZD11MT0MN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLalEWIJFdMPV6UMJR23ski4VDf_i6BQY',
    appId: '1:875064076699:android:6a5ead04331b0a9bd5d93e',
    messagingSenderId: '875064076699',
    projectId: 'civicvoice-c476a',
    storageBucket: 'civicvoice-c476a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLalEWIJFdMPV6UMJR23ski4VDf_i6BQY',
    appId: '1:875064076699:ios:6a5ead04331b0a9bd5d93e',
    messagingSenderId: '875064076699',
    projectId: 'civicvoice-c476a',
    storageBucket: 'civicvoice-c476a.firebasestorage.app',
    iosBundleId: 'com.college.civicvoice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLalEWIJFdMPV6UMJR23ski4VDf_i6BQY',
    appId: '1:875064076699:ios:6a5ead04331b0a9bd5d93e',
    messagingSenderId: '875064076699',
    projectId: 'civicvoice-c476a',
    storageBucket: 'civicvoice-c476a.firebasestorage.app',
    iosBundleId: 'com.college.civicvoice',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDLalEWIJFdMPV6UMJR23ski4VDf_i6BQY',
    appId: '1:875064076699:web:6a5ead04331b0a9bd5d93e',
    messagingSenderId: '875064076699',
    projectId: 'civicvoice-c476a',
    authDomain: 'civicvoice-c476a.firebaseapp.com',
    storageBucket: 'civicvoice-c476a.firebasestorage.app',
    measurementId: 'G-7ZD11MT0MN',
  );
}
