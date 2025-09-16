import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opzioni di configurazione predefinite per Firebase per l'app TeleRetro Italia.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'La piattaforma web non è supportata da questa app.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'La piattaforma macOS non è supportata da questa app.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'La piattaforma Windows non è supportata da questa app.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'La piattaforma Linux non è supportata da questa app.',
        );
      default:
        throw UnsupportedError(
          'La piattaforma ${defaultTargetPlatform.name} non è supportata da questa app.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkvgnOFa0soeLL0Kuu70BAwfreFdeUMtU',
    appId: '1:876587734466:android:08364a88df1f8e94b6f25b',
    messagingSenderId: '876587734466',
    projectId: 'teleretro-italia',
    storageBucket: 'teleretro-italia.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYUCI2LGZ5U34qM-uA0QtNAPIbX2Ef_GY',
    appId: '1:876587734466:ios:29d8a31a4812d2d6b6f25b',
    messagingSenderId: '876587734466',
    projectId: 'teleretro-italia',
    storageBucket: 'teleretro-italia.firebasestorage.app',
  );
}
