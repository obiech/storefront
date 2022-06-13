import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skeletons/skeletons.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/keys.dart';

import '../../../../commons.dart';
import '../../mocks.dart';

/// Payment method selection tests
void main() {
  late List<PaymentMethodDetails> paymentMethods;
  late PaymentMethodCubit paymentMethodCubit;

  setUp(() {
    /// Load sample payment methods
    paymentMethods = samplePaymentMethods.toPaymentDetails();

    paymentMethodCubit = MockPaymentMethodCubit();

    when(() => paymentMethodCubit.state)
        .thenAnswer((invocation) => InitialPaymentMethodState());
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets(
      'should show Loading Widget '
      'when [PaymentMethodCubit] state is not [LoadedPaymentMethods]',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpPaymentSelector(paymentMethodCubit);

    /// assert
    expect(find.byType(SkeletonItem), findsOneWidget);
  });

  testWidgets(
      'should display active payment method '
      'when [PaymentMethodCubit] state is [LoadedPaymentMethods]',
      (WidgetTester tester) async {
    /// arrange
    final selectedPaymentMethod = paymentMethods.first;

    when(() => paymentMethodCubit.state).thenReturn(
      LoadedPaymentMethods(paymentMethods, selectedPaymentMethod),
    );
    final context = await tester.pumpPaymentSelector(paymentMethodCubit);

    /// assert
    expect(find.text('${context.res.strings.loading} ...'), findsNothing);

    /// Pick logo and ensure that first is displayed
    final paymentSelectorLogo = tester.firstWidget<SvgPicture>(
      find.byKey(const ValueKey(PaymentMethodKeys.logo)),
    );

    expect(
      (paymentSelectorLogo.pictureProvider as ExactAssetPicture).assetName,
      selectedPaymentMethod.image,
    );
  });

  testWidgets(
      'should open payment method list '
      'when tapped', (WidgetTester tester) async {
    /// arrange
    when(() => paymentMethodCubit.state).thenReturn(
      LoadedPaymentMethods(paymentMethods, paymentMethods.first),
    );

    await tester.pumpPaymentSelector(paymentMethodCubit);

    expect(find.byType(PaymentMethodList), findsNothing);

    await tester.tap(find.byKey(const ValueKey(PaymentMethodKeys.button)));
    await tester.pumpAndSettle();

    expect(find.byType(PaymentMethodList), findsOneWidget);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpPaymentSelector(
    PaymentMethodCubit paymentMethodCubit,
  ) async {
    late BuildContext ctx;
    await pumpWidget(
      BlocProvider(
        create: (_) => paymentMethodCubit,
        child: Builder(
          builder: (context) {
            ctx = context;
            return MaterialApp(
              home: Scaffold(
                body: PaymentMethodSelector(
                  onChange: (_) {},
                ),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
