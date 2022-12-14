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
    required OrderModel order,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentInstructionsPage(order: order),
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
        order: orderAwaitingPayment.copyWith(
          paymentMethod: PaymentMethod.PAYMENT_METHOD_VA_BCA,
          paymentInformation: const PaymentInformationModel(
            vaNumber: _vaNumber,
            bankName: 'bca',
          ),
          paymentExpiryTime: DateTime.now(),
        ),
      );

      expect(find.byType(PaymentInformationSection), findsOneWidget);
      expect(find.byType(PaymentHelpSection), findsOneWidget);
      expect(find.byType(ContactSupportButton), findsOneWidget);
    },
  );
}
