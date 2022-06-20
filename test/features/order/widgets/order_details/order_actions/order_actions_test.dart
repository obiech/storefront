import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../commons.dart';
import '../../../../../src/mock_navigator.dart';
import '../../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late LaunchGoPay goPayLauncher;

  final bcaPaymentResults = mockBcaPaymentResults;
  final goPayPaymentResults = mockGoPayPaymentResults;
  final deepLink = goPayPaymentResults.paymentInformation.deeplink!;

  setUp(() {
    goPayLauncher = MockGoPayLaunch();

    when(() => goPayLauncher.call(any())).thenAnswer((_) async {});

    stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    setUpLocaleInjection();

    registerFallbackValue(FakePageRouteInfo());
  });

  final payNowButtonFinder = find.byKey(
    const ValueKey(
      OrderDetailsPageKeys.buttonPayNow,
    ),
  );

  testWidgets(
      'should trigger GoPay launcher '
      'when [Pay Now] is tapped & payment method is [GoPay]', (tester) async {
    String? calledDeeplink;

    when(() => goPayLauncher.call(any())).thenAnswer((invocation) async {
      calledDeeplink = invocation.positionalArguments.first as String;
    });

    await tester.pumpOrderActions(
      paymentResults: goPayPaymentResults,
      launchGoPay: goPayLauncher,
    );

    await tester.tap(payNowButtonFinder);

    verify(() => goPayLauncher.call(deepLink)).called(1);

    expect(deepLink, calledDeeplink);
  });

  testWidgets(
      'should go to [PaymentInstructionsPage] '
      'when [Pay Now] is tapped & payment method is [VA]', (tester) async {
    await tester.pumpOrderActions(
      paymentResults: bcaPaymentResults,
      launchGoPay: goPayLauncher,
      stackRouter: stackRouter,
    );

    await tester.tap(payNowButtonFinder);

    verifyNever(() => goPayLauncher.call(any()));

    final capturedRoutes =
        verify(() => stackRouter.push(captureAny())).captured;

    expect(capturedRoutes.length, 1);

    final routeInfo = capturedRoutes.first as PaymentInstructionsRoute;

    expect(routeInfo, isA<PaymentInstructionsRoute>());

    final args = routeInfo.args;
    expect(args!.order, bcaPaymentResults.order);
    expect(args.paymentMethod, bcaPaymentResults.paymentMethod);
    expect(args.paymentInformation, bcaPaymentResults.paymentInformation);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpOrderActions({
    required PaymentResultsModel paymentResults,
    required LaunchGoPay launchGoPay,
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderActions(
            order: paymentResults.order,
            paymentMethod: paymentResults.paymentMethod,
            paymentInformation: paymentResults.paymentInformation,
            launchGoPay: launchGoPay,
          ).withRouterScope(stackRouter),
        ),
      ),
    );
  }
}
