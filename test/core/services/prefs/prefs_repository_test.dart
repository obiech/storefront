import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';

class MockBox extends Mock implements Box {}

void main() {
  late Box _prefBox;
  late IPrefsRepository prefs;

  setUp(() {
    _prefBox = MockBox();
    prefs = PrefsRepository(_prefBox);

    final store = {};

    when(() => _prefBox.get(any(), defaultValue: any(named: 'defaultValue')))
        .thenAnswer((invocation) {
      final key = invocation.positionalArguments.first as String;
      final defaultValue = invocation.namedArguments['defaultValue'];
      return store[key] ?? defaultValue;
    });

    when(() => _prefBox.put(any(), any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments.first as String;
      final value = invocation.positionalArguments[1];
      store[key] = value;
    });
  });

  test(
      'should return indonesian locale [Locale._(id-ID)] as default '
      'when if no locale is stored '
      'and [getDeviceLocale] is called', () async {
    /// act
    final deviceLocale = prefs.getDeviceLocale();

    /// assert
    expect(deviceLocale.toLanguageTag(), 'id-ID');
  });

  test(
      'should return stored Locale '
      'when [getDeviceLocale] is called', () async {
    /// arrange
    await prefs.setDeviceLocale(const Locale('en', 'US'));

    /// act
    final deviceLocale = prefs.getDeviceLocale();

    /// assert
    expect(deviceLocale.toLanguageTag(), 'en-US');
  });
}
