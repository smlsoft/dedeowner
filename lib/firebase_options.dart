// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      apiKey: "AIzaSyCdaK9B_08CLPQSB_6KgyAmKmkI2PmZKMw",
      authDomain: "dedepos.firebaseapp.com",
      projectId: "dedepos",
      storageBucket: "dedepos.appspot.com",
      messagingSenderId: "183871505957",
      appId: "1:183871505957:web:e66bca751aaf04be07a1cc",
      measurementId: "G-NG1EX0Q767");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdaK9B_08CLPQSB_6KgyAmKmkI2PmZKMw',
    appId: '1:183871505957:android:88663850303af0db07a1cc',
    messagingSenderId: '183871505957',
    projectId: 'dedepos',
    storageBucket: 'dedepos.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtsHFrHOs-PHVPwsa35W6b6th4vCDRoqk',
    appId: '1:662224915108:ios:4573e2a62c86cda3263431',
    messagingSenderId: '662224915108',
    projectId: 'dedeowner-a6cbd',
    storageBucket: 'dedeowner-a6cbd.appspot.com',
    iosClientId: '662224915108-3tr5ja1lf8jrr9u98kbij7lshl6uid46.apps.googleusercontent.com',
    iosBundleId: 'com.smlsoft.dedeowner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtsHFrHOs-PHVPwsa35W6b6th4vCDRoqk',
    appId: '1:662224915108:ios:3e99ea002fb4a7f4263431',
    messagingSenderId: '662224915108',
    projectId: 'dedeowner-a6cbd',
    storageBucket: 'dedeowner-a6cbd.appspot.com',
    iosClientId: '662224915108-2fnf70v61eddiqsv4so7onqmglv1vp94.apps.googleusercontent.com',
    iosBundleId: 'com.smlsoft.dedeowner.RunnerTests',
  );
}
