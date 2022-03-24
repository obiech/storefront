import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../core/config/auth_config.dart';
import '../core/constants/device_platform.dart';

/// Authentication Dependency Injection Module
///
/// Setup all dependencies required for auth modules
@module
abstract class AuthModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  DevicePlatform get devicePlatform {
    if (Platform.isAndroid) {
      return DevicePlatform.android;
    } else if (Platform.isIOS) {
      return DevicePlatform.ios;
    } else {
      throw UnsupportedError(
        'Currently only supports Android and iOS platforms',
      );
    }
  }

  @lazySingleton
  DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @lazySingleton
  @Named('otpTimeOut')
  int get otpTimeOut => AuthConfig.otpTimeoutInSeconds;
}
