import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../test_commons/utils/locale_setup.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpPaymentInstructionsPage({
    required PaymentResultsModel paymentResults,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentInstructionsPage(paymentResults: paymentResults),
        ),
      ),
    );
  }
}

void main() {
  const _vaNumber = '3799583839';

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
    'Should show [PaymentInformationSection], [PaymentHelpSection] and [ContactSupportButton] '
    'when [PaymentInstructionsPage] is shown',
    (tester) async {
      await tester.pumpPaymentInstructionsPage(
        paymentResults: PaymentResultsModel(
          order: orderAwaitingPayment,
          paymentInformation: const PaymentInformationModel(
            vaNumber: _vaNumber,
            bankName: 'bca',
          ),
          paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
          expiryTime: DateTime.now(),
        ),
      );

      expect(find.byType(PaymentInformationSection), findsOneWidget);
      expect(find.byType(PaymentHelpSection), findsOneWidget);
      expect(find.byType(ContactSupportButton), findsOneWidget);
    },
  );
}
