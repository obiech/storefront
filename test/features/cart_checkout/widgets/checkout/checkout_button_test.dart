import 'package:auto_route/auto_route.dart';
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
import '../../../../src/mock_navigator.dart';
import '../../../order/mocks.dart';
import '../../mocks.dart';

void main() {
  late StackRouter stackRouter;
  late LaunchGoPay goPayLauncher;

  setUpAll(() {
    setUpLocaleInjection();
    registerFallbackValue(samplePaymentMethods.first.paymentMethod);
    registerFallbackValue(FakePageRouteInfo());
    registerFallbackValue(const LoadCart());
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

    // GoPay
    goPayLauncher = MockGoPayLaunch();
    when(() => goPayLauncher.call(any())).thenAnswer((_) async {});

    // Navigation
    stackRouter = MockStackRouter();
    when(() => stackRouter.replace(any())).thenAnswer((_) async => null);
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
      launchGoPay: goPayLauncher,
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
      launchGoPay: goPayLauncher,
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
      stackRouter: stackRouter,
      launchGoPay: goPayLauncher,
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
      launchGoPay: goPayLauncher,
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

  testWidgets(
      'should got to [OrderDetailsPage] '
      'with valid arguments '
      'and reload the cart '
      'when checkout is successful', (WidgetTester tester) async {
    // arrange
    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));
    when(() => cartBloc.add(any())).thenAnswer((_) {});

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
      stackRouter: stackRouter,
      launchGoPay: goPayLauncher,
    );

    await paymentMethodCubit.queryPaymentMethods();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CheckoutButton));

    // assert
    verify(() => cartBloc.add(const LoadCart())).called(1);

    final capturedRoutes =
        verify(() => stackRouter.replace(captureAny())).captured;

    expect(capturedRoutes.length, 1);

    final routeInfo = capturedRoutes.first as PageRouteInfo;

    expect(routeInfo, isA<OrderRouter>());

    final orderRouter = routeInfo as OrderRouter;
    expect(orderRouter.hasChildren, true);
    expect(orderRouter.initialChildren!.length, 1);

    final orderDetailsRoute = orderRouter.initialChildren!.first;
    expect(orderDetailsRoute, isA<OrderDetailsRoute>());

    final args = orderDetailsRoute.args as OrderDetailsRouteArgs;
    expect(args.order, paymentResults);
  });

  testWidgets(
      'should got to launch [Gojek] '
      'when checkout is successful '
      'and payment method is [GOPAY]', (WidgetTester tester) async {
    // arrange
    when(() => cartBloc.state).thenAnswer((_) => CartLoaded.success(cartModel));
    when(() => cartBloc.add(any())).thenAnswer((_) {});

    when(() => paymentRepository.getPaymentMethods()).thenAnswer(
      (_) async => right(samplePaymentMethods.toPaymentDetails()),
    );

    final paymentResults = mockGoPayPaymentResults;

    when(() => paymentRepository.checkoutPayment(any()))
        .thenAnswer((_) async => right(paymentResults));

    String? calledDeeplink;

    when(() => goPayLauncher.call(any())).thenAnswer((invocation) async {
      calledDeeplink = invocation.positionalArguments.first as String;
    });

    // act
    await tester.pumpCheckoutButton(
      cartBloc,
      paymentCheckoutCubit,
      paymentMethodCubit,
      stackRouter: stackRouter,
      launchGoPay: goPayLauncher,
    );

    await paymentMethodCubit.queryPaymentMethods();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CheckoutButton));

    // assert
    verify(
      () => goPayLauncher
          .call(mockGoPayPaymentResults.paymentInformation.deeplink ?? ''),
    ).called(1);

    expect(
      mockGoPayPaymentResults.paymentInformation.deeplink ?? '',
      calledDeeplink,
    );
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpCheckoutButton(
    CartBloc cartBloc,
    PaymentCheckoutCubit paymentCheckoutCubit,
    PaymentMethodCubit paymentMethodCubit, {
    StackRouter? stackRouter,
    required LaunchGoPay launchGoPay,
  }) async {
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
        child: MaterialApp(
          home: Scaffold(
            body: CheckoutButton(
              launchGoPay: launchGoPay,
            ),
          ).withRouterScope(stackRouter),
        ),
      ),
    );
  }
}
