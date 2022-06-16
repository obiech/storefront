import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

void main() {
  test('should return 1 if value is true', () async {
    const boolValue = true;

    expect(boolValue.toInt(), 1);
  });

  test('should return 0 if value is false', () async {
    const boolValue = false;

    expect(boolValue.toInt(), 0);
  });
}
