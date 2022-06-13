import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      return const FirebaseOptions(
          apiKey: 'AIzaSyBbhBsTROm4b_Lx91homqlgf3qaBtS849Y',
          authDomain: 'reciochat.appspot.com',
          databaseURL: '',
          projectId: 'reciochat',
          storageBucket: 'reciochat.appspot.com',
          messagingSenderId: '418560497563',
          appId: '1:418560497563:android:70b44e0a83a63db588b33e',
          measurementId: '');
    } else if (Platform.isIOS || Platform.isMacOS) {
      return const FirebaseOptions(
          apiKey: 'AIzaSyBbhBsTROm4b_Lx91homqlgf3qaBtS849Y',
          appId: '1:418560497563:android:70b44e0a83a63db588b33e',
          messagingSenderId: '418560497563',
          projectId: 'reciochat',
          authDomain: 'reciochat.appspot.com',
          iosBundleId: '',
          iosClientId: '',
          databaseURL: '');
    } else {
      return const FirebaseOptions(
          appId: '1:418560497563:android:70b44e0a83a63db588b33e',
          apiKey: 'AIzaSyBbhBsTROm4b_Lx91homqlgf3qaBtS849Y',
          projectId: 'reciochat',
          messagingSenderId: '418560497563',
          authDomain: 'reciochat.appspot.com',
          androidClientId:
              '418560497563-ofnut113jsh0u26i66jv6hb7p01utd6q.apps.googleusercontent.com');
    }
  }
}
