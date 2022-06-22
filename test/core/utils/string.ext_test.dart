import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

/// Unit tests for Currency conversion
void main() {
  test('should return Rp as currency if no currency is provided', () async {
    const amount = '15000';

    // assert that currency returned is "Rp 150,00"
    expect(amount.toCurrency().startsWith('Rp'), true);
  });

  test('should return 2dp for indonesian Rupiah', () async {
    // assert that millions is formatted
    var amount = '1500050';
    expect(amount.toCurrency(), 'Rp 15.000,50');

    amount = '10800056';
    expect(amount.toCurrency(), 'Rp 108.000,56');

    // assert that hundred-thousands is formatted
    amount = '150250';
    expect(amount.toCurrency(), 'Rp 1.502,50');

    // assert that hundreds is formatted
    amount = '15025';
    expect(amount.toCurrency(), 'Rp 150,25');
  });

  test(
    'should return fallback value if string length is less than 3 '
    'or is not a numerical value',
    () {
      const nonNumeric = 'abcd';

      // Test default fallback
      expect(nonNumeric.toCurrency(), 'Rp 0');
      expect(nonNumeric.toIDRFormat(), '0');

      // Test fallback values
      expect(nonNumeric.toCurrency('N/A'), 'Rp N/A');
      expect(nonNumeric.toIDRFormat('N/A'), 'N/A');

      const shortString = '01';

      // Test default fallback
      expect(shortString.toCurrency(), 'Rp 0');
      expect(shortString.toIDRFormat(), '0');

      // Test fallback values
      expect(shortString.toCurrency('N/A'), 'Rp N/A');
      expect(shortString.toIDRFormat('N/A'), 'N/A');
    },
  );

  test(
    '[isZeroCurrency] should return whether a string evaluates to zero',
    () {
      expect(''.isZeroCurrency, true);
      expect('0'.isZeroCurrency, true);
      expect('00'.isZeroCurrency, true);
      expect('000'.isZeroCurrency, true);
      expect('0000'.isZeroCurrency, true);
      expect('00000'.isZeroCurrency, true);
      expect('00000000'.isZeroCurrency, true);
      expect('abcdef'.isZeroCurrency, true);
      expect('a1c2ef'.isZeroCurrency, true);

      expect('100'.isZeroCurrency, false);
      expect('25000'.isZeroCurrency, false);
      expect('12345'.isZeroCurrency, false);
    },
  );

  test('should not return cents component if cents is zero', () {
    const noCents = '10000';
    expect(noCents.toCurrency(), 'Rp 100');

    const hasCents = '10031';
    expect(hasCents.toCurrency(), 'Rp 100,31');
  });

  group('[String].commas()', () {
    test('should work for all numbers', () async {
      const separator = '.';

      expect('1000'.formatNumber(separator), '1.000');
      expect('1050'.formatNumber(separator), '1.050');
      expect('10500'.formatNumber(separator), '10.500');
      expect('200500'.formatNumber(separator), '200.500');
      expect('2570500'.formatNumber(separator), '2.570.500');
    });
  });

  group('[String].capitalize()', () {
    test('should capitalize any string without fail', () async {
      expect(''.capitalize(), '');
      expect('some stuff'.capitalize(), 'Some stuff');
      expect('SOME STUFF'.capitalize(), 'Some stuff');
      expect('Some Stuff'.capitalize(), 'Some stuff');
      expect('SoMe STuFf'.capitalize(), 'Some stuff');
    });
  });

  group('[String].toImageUrl()', () {
    test('should join img url with host', () async {
      dotenv.testLoad(fileInput: '''ASSETS_URL=https://test.dropezy.com''');
      expect(
        'storefront/image.webp'.toImageUrl,
        'https://test.dropezy.com/storefront/image.webp',
      );
      expect(
        'storefront/123.webp'.toImageUrl,
        'https://test.dropezy.com/storefront/123.webp',
      );
    });
  });
}
