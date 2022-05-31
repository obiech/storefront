import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/dotenv.ext.dart';

/// Contains configuration related to Finger print Js services
///
/// e.g. apiKey
class FpjsConfig {
  static String get fpjsApiKey => dotenv.getString('FPJS_API_KEY');
}
