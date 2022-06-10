import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/checkout_button.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/keys.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/keys.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/selector.dart';
import 'package:storefront_app/features/cart_checkout/widgets/widgets.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/utils/payment_methods.dart';
import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  late IPaymentRepository _paymentMethodsRepository;
  late PaymentMethodCubit _cubit;
  late CartBloc _cartBloc;
  late CartModel _cartModel;

  setUp(() {
    _paymentMethodsRepository = MockPaymentMethodRepository();
    _cubit = PaymentMethodCubit(_paymentMethodsRepository);
    _cartBloc = MockCartBloc();
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
                create: (context) => _cubit,
              ),
              BlocProvider(
                create: (context) =>
                    PaymentCheckoutCubit(_paymentMethodsRepository),
              ),
              BlocProvider(
                create: (context) => _cartBloc,
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
        when(() => _cartBloc.state)
            .thenAnswer((_) => CartLoaded.success(_cartModel));
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

      /// Payment method selection tests
      group('Payment method selector', () {
        late List<PaymentChannel> paymentMethods;

        setUp(() {
          /// Load sample payment methods
          paymentMethods = samplePaymentMethods;

          when(() => _paymentMethodsRepository.getPaymentMethods()).thenAnswer(
            (_) async => right(paymentMethods.toPaymentDetails()),
          );
        });

        testWidgets('should display first payment method as default',
            (WidgetTester tester) async {
          /// Load Checkout sticky bottom sheet
          await _pumpTestWidget(tester);
          await tester.pumpAndSettle();

          /// Payment Selector widget is displayed
          final paymentSelectorFinder =
              find.byKey(const ValueKey(CheckoutKeys.payment));
          expect(paymentSelectorFinder, findsOneWidget);

          /// By default shows "Loading..." text
          expect(find.text('Loading ...'), findsOneWidget);

          /// Load payment methods
          await _cubit.queryPaymentMethods();
          await tester.pumpAndSettle();

          /// Pick logo and ensure that first is displayed
          final paymentSelectorLogo = tester.firstWidget(
            find.byKey(const ValueKey(PaymentMethodKeys.logo)),
          ) as Image;

          expect(
            (paymentSelectorLogo.image as AssetImage).assetName,
            paymentMethods.first.paymentInfo().image,
          );
        });

        /// TODO(obella465): Re-enable when we have more than one payment method
        /// Test Selecting changing payment method
        /*testWidgets('should safely toggle payment methods',
            (WidgetTester tester) async {
          /// Load Checkout sticky bottom sheet
          await _pumpTestWidget(tester, price: '12000');
          await tester.pumpAndSettle();

          await _cubit.queryPaymentMethods();
          await tester.pumpAndSettle();

          /// Tap button to launch dialog with list of payment methods
          final buttonFinder =
              find.byKey(const ValueKey(PaymentMethodKeys.button));
          expect(buttonFinder, findsOneWidget);
          await tester.tap(buttonFinder);
          await tester.pumpAndSettle();

          final paymentMethodListFinder = find.byType(PaymentMethodList);
          expect(paymentMethodListFinder, findsOneWidget);

          /// Check if all payment methods are displayed
          final List<Widget> methods = tester
              .widgetList(
                find.descendant(
                  of: paymentMethodListFinder,
                  matching: find.byType(InkWell),
                ),
              )
              .toList();
          expect(methods.length, paymentMethods.length);

          /// Tap second item in ListView
          const index = 1;
          final secondPaymentMethod = paymentMethods[index];
          final secondPaymentMethodFinder =
              find.byKey(const ValueKey('payment-method-$index'));
          expect(secondPaymentMethodFinder, findsOneWidget);

          await tester.tap(secondPaymentMethodFinder);
          await tester.pumpAndSettle();

          /// Pick logo and ensure that second is displayed
          final paymentSelectorLogo = tester.firstWidget(
            find.byKey(const ValueKey(PaymentMethodKeys.logo)),
          ) as Image;

          expect(
            (paymentSelectorLogo.image as AssetImage).assetName,
            secondPaymentMethod.paymentInfo().image,
          );
        });*/
      });

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
