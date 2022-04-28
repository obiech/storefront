import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/dotenv_extension.dart';

/// Contains access configuration for app assets
///
/// e.g assets URL
class AssetsConfig {
  /// assets url
  static String get assetsUrl => dotenv.getString('ASSETS_URL', fallback: '');
}
