import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../commons.dart';
import '../mocks.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[CartCheckoutPage]',
    () {
      late CartBloc cartBloc;
      late PaymentMethodCubit paymentMethodCubit;
      late PaymentCheckoutCubit paymentCheckoutCubit;

      setUp(() {
        cartBloc = MockCartBloc();
        paymentMethodCubit = MockPaymentMethodCubit();
        paymentCheckoutCubit = MockPaymentCheckoutCubit();
      });

      testWidgets(
        'should display a [CartBodyWidget] '
        'and [CartCheckout]',
        (WidgetTester tester) async {
          when(() => cartBloc.state).thenReturn(const CartInitial());
          when(() => paymentMethodCubit.state)
              .thenReturn(InitialPaymentMethodState());
          when(() => paymentCheckoutCubit.state)
              .thenReturn(InitialPaymentCheckoutState());

          await tester.pumpCheckoutPage(
            cartBloc: cartBloc,
            paymentCheckoutCubit: paymentCheckoutCubit,
            paymentMethodCubit: paymentMethodCubit,
          );

          expect(find.byType(CartCheckout), findsOneWidget);
          expect(find.byType(CartBodyWidget), findsOneWidget);
        },
      );
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCheckoutPage({
    required CartBloc cartBloc,
    required PaymentCheckoutCubit paymentCheckoutCubit,
    required PaymentMethodCubit paymentMethodCubit,
  }) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>(
            create: (context) => cartBloc,
          ),
          BlocProvider<PaymentCheckoutCubit>(
            create: (context) => paymentCheckoutCubit,
          ),
          BlocProvider<PaymentMethodCubit>(
            create: (context) => paymentMethodCubit,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CartCheckoutPage(),
          ),
        ),
      ),
    );
  }
}
