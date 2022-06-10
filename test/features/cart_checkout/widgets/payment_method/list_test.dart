import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/order/order.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/blocs/blocs.dart';
import 'package:storefront_app/features/cart_checkout/domain/domains.dart';
import 'package:storefront_app/features/cart_checkout/widgets/payment_method/list.dart';

import '../../../../../test_commons/utils/payment_methods.dart';
import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  late IPaymentRepository _paymentMethodsRepository;
  late PaymentMethodCubit _cubit;

  setUp(() {
    _paymentMethodsRepository = MockPaymentMethodRepository();
    _cubit = PaymentMethodCubit(_paymentMethodsRepository);
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    'Payment Methods List',
    () {
      Future<void> _pumpTestWidget(
        WidgetTester tester, {
        PaymentMethodCubit? cubit,
      }) =>
          tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PaymentMethodList(cubit: cubit ?? _cubit),
              ),
            ),
          );

      late List<PaymentChannel> paymentMethods;

      setUp(() {
        /// Load sample payment methods
        paymentMethods = samplePaymentMethods;
      });

      testWidgets(
          'When no payment methods are loaded '
          'should display empty state ', (WidgetTester tester) async {
        /// Load Payment Methods List
        when(() => _paymentMethodsRepository.getPaymentMethods())
            .thenAnswer((_) async => left(NoPaymentMethods()));

        await _pumpTestWidget(
          tester,
          cubit: PaymentMethodCubit(_paymentMethodsRepository),
        );
        await tester.pumpAndSettle();

        expect(find.text('No Payment Methods'), findsOneWidget);
      });

      testWidgets(
          'When an exception occurs while loading payment methods are loaded '
          'display error state', (WidgetTester tester) async {
        when(() => _paymentMethodsRepository.getPaymentMethods())
            .thenAnswer((_) async => left(NetworkFailure()));

        /// Load Payment Methods List
        await _pumpTestWidget(tester);
        await tester.pumpAndSettle();

        await _cubit.queryPaymentMethods();
        await tester.pumpAndSettle();

        expect(find.text('Error loading payment methods'), findsOneWidget);
      });

      testWidgets(
          'When querying payment methods is successful '
          'display full list of all payment methods availed',
          (WidgetTester tester) async {
        when(() => _paymentMethodsRepository.getPaymentMethods())
            .thenAnswer((_) async => right(paymentMethods.toPaymentDetails()));

        /// Load Payment Methods List
        await _pumpTestWidget(tester);
        await tester.pumpAndSettle();

        await _cubit.queryPaymentMethods();
        await tester.pumpAndSettle();

        for (int index = 0; index < paymentMethods.length; index++) {
          final method = paymentMethods[index];
          final _key = ValueKey('payment-method-$index');

          /// Has Payment Method Widget
          final paymentMethodWidgetFinder = find.byKey(_key);
          expect(paymentMethodWidgetFinder, findsOneWidget);

          /// Payment method logo is displayed
          final methodLogo = tester.firstWidget(
            find.descendant(
              of: paymentMethodWidgetFinder,
              matching: find.byType(Image),
            ),
          ) as Image;

          final info = method.paymentInfo();

          expect((methodLogo.image as AssetImage).assetName, info.image);

          /// Payment method title is displayed
          final methodTitle = tester.firstWidget(
            find.descendant(
              of: paymentMethodWidgetFinder,
              matching: find.byType(Text),
            ),
          ) as Text;

          expect(methodTitle.data, info.title);
        }
      });
    },
  );
}
