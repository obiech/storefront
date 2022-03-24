import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/domain/repository/phone_verification_result.dart';

void main() {
  group('Phone Verification Result', () {
    test(
      '''
      -- asserts that [exception] must not be null 
      when [status] == [PhoneVerificationStatus.error]''',
      () {
        expect(
          () => PhoneVerificationResult(
            status: PhoneVerificationStatus.error,
          ),
          throwsAssertionError,
        );

        const exception = PhoneVerificationException('Testing assertion');

        expect(
          () => PhoneVerificationResult(
            status: PhoneVerificationStatus.error,
            exception: exception,
          ),
          isNot(throwsAssertionError),
        );
      },
    );

    test(
      '''
      -- [exception] can be null when [status] 
      != [PhoneVerificationStatus.error]''',
      () {
        expect(
          () =>
              PhoneVerificationResult(status: PhoneVerificationStatus.otpSent),
          isNot(throwsAssertionError),
        );
      },
    );
  });
}
