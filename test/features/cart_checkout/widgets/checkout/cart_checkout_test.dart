import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/utils/string.ext.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/keys.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/keys.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/list.dart';
import 'package:storefront_app/features/cart_checkout/widgets/widgets.dart';

import '../../../../../test_commons/utils/payment_methods.dart';
import '../../mocks.dart';

void main() {
  late IPaymentMethodRepository _paymentMethodsRepository;
  late PaymentMethodCubit _cubit;
  setUp(() {
    _paymentMethodsRepository = MockPaymentMethodRepository();
    _cubit = PaymentMethodCubit(_paymentMethodsRepository);
  });

  group(
    'Cart Checkout Widget',
    () {
      Future<void> _pumpTestWidget(
        WidgetTester tester, {
        required String price,
        String? discount,
        String? points,
        String? preferredPaymentMethod,
      }) =>
          tester.pumpWidget(
            BlocProvider(
              create: (context) => _cubit,
              child: MaterialApp(
                home: Scaffold(
                  body: CartCheckout(
                    price: price,
                    discount: discount,
                    preferredPayment: preferredPaymentMethod,
                    points: points,
                  ),
                ),
              ),
            ),
          );

      Future<void> _testWidgetForAmount(
        WidgetTester tester, {
        String price = '19000',
        String? discount,
        required String key,
        required String result,
      }) async {
        await _pumpTestWidget(tester, price: price, discount: discount);
        await tester.pumpAndSettle();

        // assert
        final _textWidget = tester.firstWidget(
          find.byKey(
            ValueKey(key),
          ),
        ) as Text;

        expect(_textWidget.data, result);
      }

      const priceKey = CheckoutKeys.price;
      const discountKey = CheckoutKeys.discount;

      /// Price display tests
      group('Checkout Price', () {
        testWidgets(
            'should display price in Rupiahs with 2dp for whole numbers',
            (WidgetTester tester) async {
          // Price
          await _testWidgetForAmount(
            tester,
            key: priceKey,
            price: '10800',
            result: 'Rp 108,00',
          );
        });

        testWidgets('should price in Rupiahs with 2dp for cents',
            (WidgetTester tester) async {
          // Price
          await _testWidgetForAmount(
            tester,
            key: priceKey,
            price: '10856',
            result: 'Rp 108,56',
          );

          await _testWidgetForAmount(
            tester,
            key: priceKey,
            price: '10800056',
            result: 'Rp 108.000,56',
          );
        });
      });

      /// Discount display tests
      group('Checkout Discount', () {
        testWidgets(
            'should display discount in Rupiahs with 2dp for whole numbers',
            (WidgetTester tester) async {
          // Discount
          await _testWidgetForAmount(
            tester,
            key: discountKey,
            discount: '10800',
            result: 'Rp 108,00',
          );
        });

        testWidgets('should display discount in Rupiahs with 2dp for cents',
            (WidgetTester tester) async {
          // Discount
          await _testWidgetForAmount(
            tester,
            key: discountKey,
            discount: '10856',
            result: 'Rp 108,56',
          );

          await _testWidgetForAmount(
            tester,
            key: discountKey,
            discount: '10800056',
            result: 'Rp 108.000,56',
          );
        });

        testWidgets("should not display discount if it's not available",
            (WidgetTester tester) async {
          // Discount
          await _pumpTestWidget(tester, price: '19000');
          await tester.pumpAndSettle();

          // assert
          final _discountTextWidget = find.byKey(
            const ValueKey(CheckoutKeys.discount),
          );

          expect(_discountTextWidget, findsNothing);
        });
      });

      /// Payment method selection tests
      group('Payment method selector', () {
        late List<PaymentMethod> paymentMethods;

        setUp(() {
          /// Load sample payment methods
          paymentMethods = samplePaymentMethods;

          when(() => _paymentMethodsRepository.getPaymentMethods())
              .thenAnswer((_) async => paymentMethods);
        });

        testWidgets('should display first payment method as default',
            (WidgetTester tester) async {
          /// Load Checkout sticky bottom sheet
          await _pumpTestWidget(tester, price: '12000');
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
            paymentMethods.first.image,
          );
        });

        /// Test Selecting changing payment method
        testWidgets('should safely toggle payment methods',
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
            secondPaymentMethod.image,
          );
        });
      });

      /// Points display
      group('Points display', () {
        testWidgets(
            'When no points are to be won '
            'hide points display', (WidgetTester tester) async {
          /// Load Checkout sticky bottom sheet
          await _pumpTestWidget(tester, price: '12000');
          await tester.pumpAndSettle();

          expect(
            find.byKey(const ValueKey(CheckoutKeys.points)),
            findsNothing,
          );
        });

        testWidgets(
            'When points are to be won '
            'show points display with right message',
            (WidgetTester tester) async {
          /// Load Checkout sticky bottom sheet
          const pointsWon = '50';
          await _pumpTestWidget(tester, price: '12000', points: pointsWon);
          await tester.pumpAndSettle();

          final pointsDisplayFinder =
              find.byKey(const ValueKey(CheckoutKeys.points));
          expect(
            pointsDisplayFinder,
            findsOneWidget,
          );

          final pointsMessageFinder = find.descendant(
            of: pointsDisplayFinder,
            matching: find.byType(RichText),
          );

          expect(pointsMessageFinder, findsOneWidget);

          final pointsMessageWidget =
              tester.firstWidget(pointsMessageFinder) as RichText;

          final pointsTextSpanWidget = (pointsMessageWidget.text as TextSpan)
              .children
              ?.first as TextSpan?;

          expect(
            pointsTextSpanWidget?.text,
            '${pointsWon.toIDRFormat()} coins',
          );
        });
      });
    },
  );
}
