import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/core.module.dart';
import 'package:storefront_app/res/strings/english_strings.dart';
import 'package:storefront_app/res/strings/indonesian_strings.dart';

import '../widget/onboarding/onboarding_page_test.dart';

void main() {
  late IPrefsRepository prefs;
  final coreModule = CoreModuleSetup();

  setUp(() {
    prefs = MockPrefsRepository();
  });

  test('should return [BaseString] depending on [IPrefsRepository] locale',
      () async {
    /// Indonesian
    when(() => prefs.getDeviceLocale())
        .thenAnswer((invocation) => const Locale('id', 'ID'));

    expect(coreModule.appStrings(prefs), isA<IndonesianStrings>());

    /// English
    when(() => prefs.getDeviceLocale())
        .thenAnswer((invocation) => const Locale('en', 'EN'));

    expect(coreModule.appStrings(prefs), isA<EnglishStrings>());
  });
}

class CoreModuleSetup extends CoreModule {}
