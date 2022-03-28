import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/string.ext.dart';

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

    // assert that hundred-thousands is formatted
    amount = '150250';
    expect(amount.toCurrency(), 'Rp 1.502,50');

    // assert that hundreds is formatted
    amount = '15025';
    expect(amount.toCurrency(), 'Rp 150,25');

    // assert that cents are formatted
    amount = '15';
    expect(amount.toCurrency(), 'Rp 0,15');
  });

  test('should return Rp 0,00 for non numeric amount', () async {
    const amount = 'abcd';
    expect(amount.toCurrency(), 'Rp 0,00');
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
}
