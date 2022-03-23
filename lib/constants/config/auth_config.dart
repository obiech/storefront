import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/dotenv_extension.dart';

/// Contains configuration related to Authentication services
///
/// e.g. timeout duration for OTP verification
class AuthConfig {
  static int get otpTimeoutInSeconds => dotenv.getInt('OTP_TIMEOUT');

  // Firebase auth emulator port configuration
  static int get authEmulatorPort =>
      dotenv.getInt('FIREBASE_AUTH_PORT', fallback: 9099);

  // Firebase auth emulator host configuration
  static String get authEmulatorHost =>
      Platform.isAndroid ? '10.0.2.2' : '0.0.0.0';
}
