import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
      // throw UnsupportedError(
      //   'DefaultFirebaseOptions have not been configured for web - '
      //   'you can reconfigure this by running the FlutterFire CLI again.',
      // );
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
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhpbcNRfjOz9WkG4fyLSRK5J2CzbmO6Y4',
    appId: '1:598301076946:android:0cc1713f044de96fdf6c0b',
    messagingSenderId: '598301076946',
    projectId: 'instax-59310',
    storageBucket: 'instax-59310.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0w7Aud7uFArJCTxqs84HZg9lmfU9tyG0',
    appId: '1:598301076946:ios:2fb395612388abf2df6c0b',
    messagingSenderId: '598301076946',
    projectId: 'instax-59310',
    storageBucket: 'instax-59310.appspot.com',
    androidClientId: '598301076946-68i37cpshrlnpm5cthaqadej4jjdvr63.apps.googleusercontent.com',
    iosClientId: '598301076946-l5c1hj2t8i559o95csgsdusehg086pus.apps.googleusercontent.com',
    iosBundleId: 'com.klilmhdi.zinsta.zinsta',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAluvetWEc9bN19bJT1-PiO8OJBrOvy-40",
    authDomain: "instax-59310.firebaseapp.com",
    projectId: "instax-59310",
    storageBucket: "instax-59310.appspot.com",
    messagingSenderId: "598301076946",
    appId: "1:598301076946:web:764e183b32371236df6c0b",
    measurementId: "G-H486LRN5MT",
  );
}
