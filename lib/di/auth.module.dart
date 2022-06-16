import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/di/config/di_config.dart';

import '../core/core.dart';
import '../features/auth/domain/domain.dart';
import '../features/auth/domain/services/dummy_auth_service.dart';

/// Authentication Dependency Injection Module
///
/// Setup all dependencies required for auth modules
@module
abstract class AuthModule {
  /// Returns a [FirebaseAuthService] when explicitly set to enabled
  /// or if this is a release build.
  ///
  /// Enable [DiConfig.enableFirebaseAuth] to test Authentication
  /// with Firebase Auth.
  ///
  /// Otherwise, it's advised to disable it when developing
  /// other features that does not need Firebase Auth to skip
  /// the authentication process.
  @lazySingleton
  AuthService authService(
    FirebaseAuth firebaseAuth,
    IPrefsRepository prefsRepository,
  ) {
    if (DiConfig.enableFirebaseAuth || kReleaseMode) {
      return FirebaseAuthService(
        firebaseAuth: firebaseAuth,
        otpTimeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
      );
    } else {
      return DummyAuthService(prefsRepository);
    }
  }
}
