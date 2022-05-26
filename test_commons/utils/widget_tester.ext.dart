import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// An attempt to mimic FlutterDriver's waitFor
extension WidgetTesterX on WidgetTester {
  /// Use this when a [pumpAndSettle] cannot be used (e.g. multiple animations
  /// on page) and [pump] is too inflexible (e.g. waiting for an API call
  /// to finish).
  ///
  /// Repeatedly calls [pump] for a duration of [interval] until
  /// [evaluateCondition] resolves to true.
  ///
  /// Will throw [TimeoutException] if
  /// it does not resolve to true within specified [timeout].
  Future<void> waitFor({
    Duration interval = const Duration(milliseconds: 100),
    Duration timeout = const Duration(seconds: 10),
    required bool Function() evaluateCondition,
    String? errorMsg,
  }) async {
    bool conditionIsSatisfied = false;

    final endTime = DateTime.now().add(timeout);

    while (!conditionIsSatisfied) {
      conditionIsSatisfied = evaluateCondition();

      await pump(interval);

      if (DateTime.now().isAfter(endTime)) {
        throw TimeoutException(errorMsg ?? 'waitFor timed out.');
      }
    }
  }

  /// Enters [text] letter by letter instead of the whole string at once.
  ///
  /// For example to enter text in e2e test and observe the animation.
  Future<void> enterTextLetterByLetter(Finder finder, String text) async {
    for (int i = 0; i < text.length; i++) {
      await enterText(
        finder,
        text.substring(0, i + 1),
      );
      await pump(const Duration(milliseconds: 50));
    }
  }
}
