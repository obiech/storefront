import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../core/config/auth_config.dart';
import 'di_environment.dart';

/// Firebase dependencies module
///
/// Dependencies provision for [FirebaseAuth] service
@module
abstract class FirebaseAuthSingleton {
  @LazySingleton(env: [DiEnvironment.prod])
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @LazySingleton(env: [DiEnvironment.dev, DiEnvironment.dummy])
  FirebaseAuth get firebaseAuthDev {
    final instance = FirebaseAuth.instance;

    instance.useAuthEmulator(
      AuthConfig.authEmulatorHost,
      AuthConfig.authEmulatorPort,
    );

    return instance;
  }
}
