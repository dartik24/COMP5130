import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCv9dEMV5zjBOIZ8582PiKJYX3ZdWi55c8',
    appId: '1:566080123088:web:e84b09c4530601af5b2ed5',
    messagingSenderId: '566080123088',
    projectId: 'comp5130',
    authDomain: 'comp5130.firebaseapp.com',
    storageBucket: 'comp5130.appspot.com',
    measurementId: 'G-KGFM2ED1TT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaKFAlamBdQpVKGf-oxWIH7ubI1GeDYMM',
    appId: '1:566080123088:android:48feaa145a95e84c5b2ed5',
    messagingSenderId: '566080123088',
    projectId: 'comp5130',
    storageBucket: 'comp5130.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD4eUYCIRU3Ytjl8KlETppsfdjT2HOMc4',
    appId: '1:566080123088:ios:5bb35ad3ae16e6225b2ed5',
    messagingSenderId: '566080123088',
    projectId: 'comp5130',
    storageBucket: 'comp5130.appspot.com',
    iosBundleId: 'com.example.comp5130Project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDD4eUYCIRU3Ytjl8KlETppsfdjT2HOMc4',
    appId: '1:566080123088:ios:5bb35ad3ae16e6225b2ed5',
    messagingSenderId: '566080123088',
    projectId: 'comp5130',
    storageBucket: 'comp5130.appspot.com',
    iosBundleId: 'com.example.comp5130Project',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv9dEMV5zjBOIZ8582PiKJYX3ZdWi55c8',
    appId: '1:566080123088:web:08d1585140d9aa855b2ed5',
    messagingSenderId: '566080123088',
    projectId: 'comp5130',
    authDomain: 'comp5130.firebaseapp.com',
    storageBucket: 'comp5130.appspot.com',
    measurementId: 'G-Y6CZEF2TNZ',
  );
}
