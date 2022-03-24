import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../core/config/auth_config.dart';

/// Firebase dependencies module
///
/// Dependencies provision for [FirebaseAuth] service
@module
abstract class FirebaseAuthSingleton {
  @LazySingleton(env: [Environment.prod])
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @LazySingleton(env: [Environment.dev])
  FirebaseAuth get firebaseAuthDev {
    final instance = FirebaseAuth.instance;

    instance.useAuthEmulator(
      AuthConfig.authEmulatorHost,
      AuthConfig.authEmulatorPort,
    );

    return instance;
  }
}
