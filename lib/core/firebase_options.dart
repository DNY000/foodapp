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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMkUV4BSvwKL2NP6mwo_0-b-BEtiXYgFs',
    appId: '1:44206956684:android:ce1750bd1930bf8f8f9ba9',
    messagingSenderId: '44206956684',
    projectId: 'foodapp-daade',
    storageBucket: 'foodapp-daade.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2ma-Oq1ktQWSyrW6Fj49yCqUPMQki0ng',
    appId: '1:44206956684:ios:b8048e404f65fa2f8f9ba9',
    messagingSenderId: '44206956684',
    projectId: 'foodapp-daade',
    storageBucket: 'foodapp-daade.appspot.com',
    androidClientId: '44206956684-l7ve5tnlk78vfg8h63v3cai4i41rvv4p.apps.googleusercontent.com',
    iosClientId: '44206956684-jmqnbfhmmdtaufkl7jutuc548sjoig3f.apps.googleusercontent.com',
    iosBundleId: 'com.codeforany.multiFoodRestaurants',
  );
}
