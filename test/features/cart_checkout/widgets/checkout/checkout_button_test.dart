import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/checkout_button.dart';

import '../../../../../test_commons/finders/cart_checkout_screen_finders.dart';
import '../../../../../test_commons/utils/payment_methods.dart';
import '../../mocks.dart';

void main() {
  group('[CheckoutButton]', () {
    late PaymentCheckoutCubit _cubit;
    late PaymentMethodCubit _paymentMethodsCubit;
    late IPaymentRepository _repository;

    setUp(() {
      _repository = MockPaymentMethodRepository();
      _cubit = PaymentCheckoutCubit(_repository);

      /// Payment methods
      // when(() => _repository.getPaymentMethods())
      //     .thenAnswer((_) async => samplePaymentMethods);

      _paymentMethodsCubit = PaymentMethodCubit(_repository);

      registerFallbackValue(samplePaymentMethods.first.paymentMethod);
    });

    Future<void> _pumpTestWidget(WidgetTester tester) => tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => _cubit,
              ),
              BlocProvider(
                create: (context) => _paymentMethodsCubit,
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: CheckoutButton(),
              ),
            ),
          ),
        );

    testWidgets(
        'When there is no selected payment method '
        'should be disabled', (WidgetTester tester) async {
      /// arrange
      when(() => _repository.getPaymentMethods()).thenAnswer((_) async => []);

      /// act
      await _pumpTestWidget(tester);
      await tester.pumpAndSettle();

      /// assert
      expect(CartCheckoutScreenFinders.buyButton, findsOneWidget);
      expect(CartCheckoutScreenFinders.buyElevatedButton, findsOneWidget);

      final checkoutElevatedButton = tester
          .widget<ElevatedButton>(CartCheckoutScreenFinders.buyElevatedButton);
      expect(checkoutElevatedButton.enabled, false);
    });

    testWidgets(
        'When checkout is initiated '
        'should show loading', (WidgetTester tester) async {
      /// arrange
      when(() => _repository.getPaymentMethods())
          .thenAnswer((_) async => samplePaymentMethods);

      when(() => _repository.checkoutPayment(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 2));
        return '';
      });

      /// act
      await _pumpTestWidget(tester);
      await _paymentMethodsCubit.queryPaymentMethods();
      await tester.pumpAndSettle();

      /// assert
      expect(CartCheckoutScreenFinders.buyButton, findsOneWidget);
      expect(CartCheckoutScreenFinders.buyElevatedButton, findsOneWidget);

      /// Ensure is enabled
      expect(
        tester
            .widget<ElevatedButton>(CartCheckoutScreenFinders.buyElevatedButton)
            .enabled,
        true,
      );

      await tester.tap(CartCheckoutScreenFinders.buyElevatedButton);
      await tester.pump();

      expect(
        tester
            .widget<DropezyButton>(CartCheckoutScreenFinders.buyButton)
            .isLoading,
        true,
      );

      await tester.pumpAndSettle();
    });

    testWidgets(
        'When there is an error checking out '
        'should show error snackbar', (WidgetTester tester) async {
      /// arrange
      when(() => _repository.getPaymentMethods())
          .thenAnswer((_) async => samplePaymentMethods);
      when(() => _repository.checkoutPayment(any()))
          .thenThrow(Exception('Error checking out'));

      /// act
      await _pumpTestWidget(tester);
      await tester.pumpAndSettle();
      await _paymentMethodsCubit.queryPaymentMethods();
      await tester.pumpAndSettle();

      verify(() => _repository.getPaymentMethods()).called(2);

      /// assert
      expect(CartCheckoutScreenFinders.buyButton, findsOneWidget);
      expect(CartCheckoutScreenFinders.buyElevatedButton, findsOneWidget);

      /// Ensure is enabled
      expect(
        tester
            .widget<ElevatedButton>(CartCheckoutScreenFinders.buyElevatedButton)
            .enabled,
        true,
      );

      await tester.tap(CartCheckoutScreenFinders.buyElevatedButton);
      await tester.pump();
      verify(() => _repository.checkoutPayment(any())).called(1);

      expect(find.text('Error checking out'), findsOneWidget);
    });
  });
}
