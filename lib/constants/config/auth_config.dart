import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/dotenv_extension.dart';

/// Contains configuration related to Authentication services
///
/// e.g. timeout duration for OTP verification
class AuthConfig {
  static int get otpTimeoutInSeconds => dotenv.getInt('OTP_TIMEOUT');
}
