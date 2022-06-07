import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/features/order/finders/order_history_page_finders.dart';
import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/utils/sample_order_models.dart';
import '../../../cart_checkout/mocks.dart';
import '../../mocks.dart';

void main() {
  late OrderHistoryCubit orderHistoryCubit;
  late CartBloc cartBloc;

  setUp(() {
    orderHistoryCubit = MockOrderHistoryCubit();
    cartBloc = MockCartBloc();
  });

  Future<void> pumpOrderHistoryPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<OrderHistoryCubit>(
              create: (_) => orderHistoryCubit,
            ),
            BlocProvider(
              create: (context) => cartBloc,
            ),
          ],
          child: const OrderHistoryPage(),
        ),
      ),
    );
  }

  group('[OrderHistoryPage]', () {
    setUp(() {
      when(() => cartBloc.state).thenAnswer(
        (_) => CartLoaded.success(mockCartModel),
      );
    });

    testWidgets('should display a floating cart summary', (tester) async {
      when(() => orderHistoryCubit.state)
          .thenAnswer((invocation) => OrderHistoryLoading());

      await pumpOrderHistoryPage(tester);

      expect(find.byType(CartSummary), findsOneWidget);
    });

    testWidgets(
      'should display a Loading Indicator when state is [OrderHistoryLoading]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((invocation) => OrderHistoryLoading());

        await pumpOrderHistoryPage(tester);

        expect(OrderHistoryFinders.loadingWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display list of Orders when state is [OrderHistoryLoaded]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((_) => OrderHistoryLoaded(sampleOrderModels));

        await pumpOrderHistoryPage(tester);

        expect(OrderHistoryFinders.listWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display no orders message when state is [OrderHistoryLoaded] '
      'but orders list is empty',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((invocation) => const OrderHistoryLoaded([]));

        await pumpOrderHistoryPage(tester);

        expect(OrderHistoryFinders.noOrdersWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display list of Orders when state is [OrderHistoryLoadingError]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((_) => const OrderHistoryLoadingError('fake error'));

        await pumpOrderHistoryPage(tester);

        expect(OrderHistoryFinders.errorWidget, findsOneWidget);
        expect(find.text('fake error'), findsOneWidget);
      },
    );
  });
}
