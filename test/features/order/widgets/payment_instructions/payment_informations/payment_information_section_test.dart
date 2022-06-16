import 'package:auto_route/auto_route.dart';
import 'package:dropezy_proto/v1/order/order.pbenum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../../test_commons/finders/payment_instructions/payment_informations_section_finder.dart';
import '../../../../../../test_commons/fixtures/order/order_models.dart';
import '../../../../../../test_commons/utils/locale_setup.dart';
import '../../../../../src/mock_navigator.dart';

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<void> pumpPaymentInformationSection({
    required PaymentResultsModel paymentResults,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaymentInformationSection(
            order: paymentResults.order,
            paymentInformation: paymentResults.paymentInformation,
            paymentMethod: paymentResults.paymentMethod,
          ),
        ),
      ),
    );
  }
}

void main() {
  late StackRouter stackRouter;
  const _vaNumber = '3799583839';

  setUp(() {
    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((invocation) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());

    setUpLocaleInjection();
  });

  group('[PaymentInformationSection]', () {
    testWidgets(
      'Should show Illustration SVG, finish payment text, expiry time, countdown '
      '[OrderAfterVerifyContainer], [PaymentMethodTile], [VirtualAccountTile], and [TotalBillTile]',
      (tester) async {
        await tester.pumpPaymentInformationSection(
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

        expect(
          PaymentInformationsSectionFinder.finderIllustrationSVG,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderFinishPaymentBeforeText,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderExpiryTimeText,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderCountdown,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderProcessOrderAfterVerifyText,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderPaymentMethodTile,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderVirtualAccountTile,
          findsOneWidget,
        );
        expect(
          PaymentInformationsSectionFinder.finderTotalBillTile,
          findsOneWidget,
        );
      },
    );
  });
}
