import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/dotenv_extension.dart';
import '../utils/is_test_mode.dart';

/// Contains configuration for Tests.
///
/// Currently contains variable for checking if this is e2e test.
/// In the future we can add more configuration such as user credentials
/// to be used in e2e tests.
class TestConfig {
  /// As a note, [kTestMode] does not return true when run using integation_test.
  /// Use this boolean if you need to setup configuration for E2E tests.
  static bool get isEndToEndTest => dotenv.getBool(
        'IS_E2E_TEST',
        fallback: false,
      );
}
