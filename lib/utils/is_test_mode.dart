import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Similar to [kDebugMode] and [kReleaseMode]; to check if current environemnt
/// is test mode.
///
/// Code obtained from:
/// https://stackoverflow.com/questions/58407382/check-if-app-is-running-in-a-testing-environment
final kTestMode = Platform.environment.containsKey('FLUTTER_TEST');
