import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/checkout_button.dart';
import 'package:storefront_app/features/cart_checkout/widgets/widgets.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  late PaymentMethodCubit paymentMethodCubit;
  late PaymentCheckoutCubit paymentCheckoutCubit;
  late CartBloc cartBloc;
  late CartModel _cartModel;

  setUp(() {
    paymentMethodCubit = MockPaymentMethodCubit();
    paymentCheckoutCubit = MockPaymentCheckoutCubit();
    cartBloc = MockCartBloc();
    _cartModel = mockCartModel;
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    'Cart Checkout Widget',
    () {
      Future<void> _pumpTestWidget(WidgetTester tester) {
        return tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => paymentMethodCubit,
              ),
              BlocProvider(
                create: (context) => paymentCheckoutCubit,
              ),
              BlocProvider(
                create: (context) => cartBloc,
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: CartCheckout(),
              ),
            ),
          ),
        );
      }

      setUp(() {
        final paymentMethods = samplePaymentMethods.toPaymentDetails().toList();

        when(() => cartBloc.state)
            .thenAnswer((_) => CartLoaded.success(_cartModel));

        when(() => paymentMethodCubit.state).thenAnswer(
          (_) => LoadedPaymentMethods(paymentMethods, paymentMethods.first),
        );

        when(() => paymentCheckoutCubit.state).thenAnswer(
          (_) => InitialPaymentCheckoutState(),
        );
      });

      testWidgets(
        'should display [CheckoutDetails], [PaymentMethodSelector] '
        'and [CheckoutButton]',
        (WidgetTester tester) async {
          await _pumpTestWidget(tester);
          await tester.pumpAndSettle();

          expect(find.byType(CheckoutDetails), findsOneWidget);
          expect(find.byType(PaymentMethodSelector), findsOneWidget);
          expect(find.byType(CheckoutButton), findsOneWidget);
        },
      );

      /// Points display (TEMPORARILY HIDDEN)
      // group('Points display', () {
      //   testWidgets(
      //       'When no points are to be won '
      //       'hide points display', (WidgetTester tester) async {
      //     /// Load Checkout sticky bottom sheet
      //     await _pumpTestWidget(tester);
      //     await tester.pumpAndSettle();

      //     expect(
      //       find.byKey(const ValueKey(CheckoutKeys.points)),
      //       findsNothing,
      //     );
      //   });

      //   testWidgets(
      //       'When points are to be won '
      //       'show points display with right message',
      //       (WidgetTester tester) async {
      //     /// Load Checkout sticky bottom sheet
      //     const pointsWon = '5000';
      //     await _pumpTestWidget(tester);
      //     await tester.pumpAndSettle();

      //     final pointsDisplayFinder =
      //         find.byKey(const ValueKey(CheckoutKeys.points));
      //     expect(
      //       pointsDisplayFinder,
      //       findsOneWidget,
      //     );

      //     final pointsMessageFinder = find.descendant(
      //       of: pointsDisplayFinder,
      //       matching: find.byType(RichText),
      //     );

      //     expect(pointsMessageFinder, findsOneWidget);

      //     final pointsMessageWidget =
      //         tester.firstWidget(pointsMessageFinder) as RichText;

      //     final pointsTextSpanWidget = (pointsMessageWidget.text as TextSpan)
      //         .children
      //         ?.first as TextSpan?;

      //     expect(
      //       pointsTextSpanWidget?.text,
      //       '${pointsWon.toIDRFormat()} coins',
      //     );
      //   });
      // });
    },
  );
}
