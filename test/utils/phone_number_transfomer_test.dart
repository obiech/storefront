import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/utils/phone_number_transformer.dart';

void main() {
  group(
      '[trimAndTransformPhoneToIntlFormat()] returns phone number '
      'prefixed with +62', () {
    test(
      'given an input that does not start with 08',
      () {
        const phone1 = '81234567890';
        const phone2 = '811111111';
        const phone3 = '8571234567';
        const phoneWithWhitespace = ' 81234567890 ';

        expect(trimAndTransformPhoneToIntlFormat(phone1), '+6281234567890');
        expect(trimAndTransformPhoneToIntlFormat(phone2), '+62811111111');
        expect(trimAndTransformPhoneToIntlFormat(phone3), '+628571234567');
        expect(
          trimAndTransformPhoneToIntlFormat(phoneWithWhitespace),
          '+6281234567890',
        );
      },
    );

    test(
      'given an input that starts with 08',
      () {
        const phone1 = '081234567890';
        const phone2 = '0811111111';
        const phone3 = '08571234567';
        const phoneWithWhitespace = ' 081234567890 ';

        expect(trimAndTransformPhoneToIntlFormat(phone1), '+6281234567890');
        expect(trimAndTransformPhoneToIntlFormat(phone2), '+62811111111');
        expect(trimAndTransformPhoneToIntlFormat(phone3), '+628571234567');
        expect(
          trimAndTransformPhoneToIntlFormat(phoneWithWhitespace),
          '+6281234567890',
        );
      },
    );
  });

  group(
      '[trimAndTransformPhoneToLocalFormat()] returns phone number '
      'prefixed with 0', () {
    test(
      'given an input that does not start with 08',
      () {
        const phone1 = '81234567890';
        const phone2 = '811111111';
        const phone3 = '8571234567';
        const phoneWithWhitespace = ' 81234567890 ';

        expect(trimAndTransformPhoneToLocalFormat(phone1), '081234567890');
        expect(trimAndTransformPhoneToLocalFormat(phone2), '0811111111');
        expect(trimAndTransformPhoneToLocalFormat(phone3), '08571234567');
        expect(
          trimAndTransformPhoneToLocalFormat(phoneWithWhitespace),
          '081234567890',
        );
      },
    );

    test(
      'given an input that starts with 08',
      () {
        const phone1 = '081234567890';
        const phone2 = '0811111111';
        const phone3 = '08571234567';
        const phoneWithWhitespace = ' 081234567890 ';

        expect(trimAndTransformPhoneToLocalFormat(phone1), '081234567890');
        expect(trimAndTransformPhoneToLocalFormat(phone2), '0811111111');
        expect(trimAndTransformPhoneToLocalFormat(phone3), '08571234567');
        expect(
          trimAndTransformPhoneToLocalFormat(phoneWithWhitespace),
          '081234567890',
        );
      },
    );
  });
}
