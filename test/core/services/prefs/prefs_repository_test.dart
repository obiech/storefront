import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/core/core.dart';

void main() {
  test(
      'should return indonesian locale [Locale._(id-ID)] as default '
      'when if no locale is stored '
      'and [getDeviceLocale] is called', () async {
    /// arrange
    SharedPreferences.setMockInitialValues({});
    final repo = PrefsRepository(await SharedPreferences.getInstance());

    /// act
    final deviceLocale = await repo.getDeviceLocale();

    /// assert
    expect(deviceLocale.toLanguageTag(), 'id-ID');
  });

  test(
      'should return stored Locale '
      'when [getDeviceLocale] is called', () async {
    /// arrange
    SharedPreferences.setMockInitialValues({PrefsKeys.kDeviceLocale: 'en-US'});

    final repo = PrefsRepository(await SharedPreferences.getInstance());

    /// act
    final deviceLocale = await repo.getDeviceLocale();

    /// assert
    expect(deviceLocale.toLanguageTag(), 'en-US');
  });
}
