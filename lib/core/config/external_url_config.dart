import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/dotenv.ext.dart';

/// Contains URLs to External Websites, most likely to be used with
/// WebViews.
///
/// For example:
/// - Dropezy website e.g Privacy Policy and T&C
/// - 3rd party tools or partner website
///
/// Make sure to call [dotenv.load()] before using this class
class ExternalUrlConfig {
  static String get urlPrivacyPolicy => dotenv.getString('URL_PRIVACY_POLICY');

  static String get urlTermsConditions =>
      dotenv.getString('URL_TERMS_CONDITIONS');
}
