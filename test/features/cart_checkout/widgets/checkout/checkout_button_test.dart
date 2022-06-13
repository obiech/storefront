import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/checkout_button.dart';

import '../../../../../test_commons/finders/cart_checkout_page_finders.dart';
import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../commons.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  late CartBloc cartBloc;
  late CartModel cartModel;
  late PaymentCheckoutCubit paymentCheckoutCubit;
  late PaymentMethodCubit paymentMethodCubit;
  late IPaymentRepository paymentRepository;
  final paymentResults = mockGoPayPaymentResults;

  setUp(() {
    cartBloc = MockCartBloc();
    cartModel = mockCartModel;
    paymentRepository = MockPaymentMethodRepository();
    paymentCheckoutCubit = PaymentCheckoutCubit(paymentRepository);

    paymentMethodCubit = PaymentMethodCubit(paymentRepository);

    registerFallbackValue(samplePaymentMethods.first.paymentMethod);
  });

  testWidgets(
      'When there is no selected payment method '
      'should be disabled', (WidgetTester tester) async {
    /// arrange
    when(() => paymentRepository.getPaymentMethods())
        .thenAnswer((_) async => left(NoPaymentMethods()));

    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

    /// act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
    );
    await tester.pumpAndSettle();

    /// assert
    expect(CartCheckoutPageFinders.buyButton, findsOneWidget);
    expect(CartCheckoutPageFinders.buyElevatedButton, findsOneWidget);

    final checkoutElevatedButton = tester
        .widget<ElevatedButton>(CartCheckoutPageFinders.buyElevatedButton);
    expect(checkoutElevatedButton.enabled, false);
  });

  testWidgets(
      'When calculating cart summary '
      'should be disabled', (WidgetTester tester) async {
    /// arrange
    when(() => paymentRepository.getPaymentMethods()).thenAnswer(
      (_) async => right(samplePaymentMethods.toPaymentDetails()),
    );

    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.loading(cartModel));

    /// act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
    );
    await tester.pumpAndSettle();

    /// assert
    expect(CartCheckoutPageFinders.buyButton, findsOneWidget);
    expect(CartCheckoutPageFinders.buyElevatedButton, findsOneWidget);

    final checkoutElevatedButton = tester
        .widget<ElevatedButton>(CartCheckoutPageFinders.buyElevatedButton);
    expect(checkoutElevatedButton.enabled, false);
  });

  testWidgets(
      'When checkout is initiated '
      'should show loading', (WidgetTester tester) async {
    /// arrange
    when(() => paymentRepository.getPaymentMethods()).thenAnswer(
      (_) async => right(samplePaymentMethods.toPaymentDetails()),
    );

    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

    when(() => paymentRepository.checkoutPayment(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 2));
      return right(
        paymentResults,
      );
    });

    /// act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
    );
    await paymentMethodCubit.queryPaymentMethods();
    await tester.pumpAndSettle();

    /// assert
    expect(CartCheckoutPageFinders.buyButton, findsOneWidget);
    expect(CartCheckoutPageFinders.buyElevatedButton, findsOneWidget);

    /// Ensure is enabled
    expect(
      tester
          .widget<ElevatedButton>(CartCheckoutPageFinders.buyElevatedButton)
          .enabled,
      true,
    );

    await tester.tap(CartCheckoutPageFinders.buyElevatedButton);
    await tester.pump();

    expect(
      tester.widget<DropezyButton>(CartCheckoutPageFinders.buyButton).isLoading,
      true,
    );

    await tester.pumpAndSettle();
  });

  testWidgets(
      'When there is an error checking out '
      'should show error snackbar', (WidgetTester tester) async {
    /// arrange
    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

    when(() => paymentRepository.getPaymentMethods()).thenAnswer(
      (_) async => right(samplePaymentMethods.toPaymentDetails()),
    );

    when(() => paymentRepository.checkoutPayment(any()))
        .thenAnswer((_) async => left(NetworkFailure('')));

    /// act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
    );
    await tester.pumpAndSettle();
    await paymentMethodCubit.queryPaymentMethods();
    await tester.pumpAndSettle();

    verify(() => paymentRepository.getPaymentMethods()).called(1);

    /// assert
    expect(CartCheckoutPageFinders.buyButton, findsOneWidget);
    expect(CartCheckoutPageFinders.buyElevatedButton, findsOneWidget);

    /// Ensure is enabled
    expect(
      tester
          .widget<ElevatedButton>(CartCheckoutPageFinders.buyElevatedButton)
          .enabled,
      true,
    );

    await tester.tap(CartCheckoutPageFinders.buyElevatedButton);
    await tester.pump();
    verify(() => paymentRepository.checkoutPayment(any())).called(1);

    expect(
      find.ancestor(
        of: find.text('Error checking out'),
        matching: find.byType(SnackBar),
      ),
      findsOneWidget,
    );
  });

  /* TODO(obella): Stub URL Launching

      testWidgets('should launch deeplink when checkout is successful',
      (WidgetTester tester) async {
    // arrange
    when(() => launch(any())).thenAnswer((invocation) async => true);
    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));

    when(() => paymentRepository.getPaymentMethods()).thenAnswer(
      (_) async => right(samplePaymentMethods.toPaymentDetails()),
    );

    final paymentResults = mockGoPayPaymentResults;

    when(() => paymentRepository.checkoutPayment(any()))
        .thenAnswer((_) async => right(paymentResults));

    // act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
    );

    await tester.tap(find.byType(CheckoutButton));
    // assert
  });*/
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCheckoutButton(
    CartBloc cartBloc,
    PaymentCheckoutCubit paymentCheckoutCubit,
    PaymentMethodCubit paymentMethodCubit,
  ) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => cartBloc,
          ),
          BlocProvider(
            create: (context) => paymentCheckoutCubit,
          ),
          BlocProvider(
            create: (context) => paymentMethodCubit,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CheckoutButton(),
          ),
        ),
      ),
    );
  }
}
