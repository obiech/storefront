import 'package:injectable/injectable.dart';

import '../core/config/auth_config.dart';

/// Authentication Dependency Injection Module
///
/// Setup all dependencies required for auth modules
@module
abstract class AuthModule {
  @lazySingleton
  @Named('otpTimeOut')
  int get otpTimeOut => AuthConfig.otpTimeoutInSeconds;
}
