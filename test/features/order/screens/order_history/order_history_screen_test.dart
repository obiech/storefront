import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/features/order/finders/order_history_screen_finders.dart';
import '../../../../../test_commons/utils/sample_order_models.dart';
import '../../mocks.dart';

void main() {
  late OrderHistoryCubit orderHistoryCubit;

  setUp(() {
    orderHistoryCubit = MockOrderHistoryCubit();
  });

  Future<void> pumpOrderHistoryScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrderHistoryCubit>(
          create: (_) => orderHistoryCubit,
          child: const OrderHistoryScreen(),
        ),
      ),
    );
  }

  group('[OrderHistoryScreen]', () {
    testWidgets(
      'should display a Loading Indicator when state is [OrderHistoryLoading]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((invocation) => OrderHistoryLoading());

        await pumpOrderHistoryScreen(tester);

        expect(OrderHistoryFinders.loadingWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display list of Orders when state is [OrderHistoryLoaded]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((_) => OrderHistoryLoaded(sampleOrderModels));

        await pumpOrderHistoryScreen(tester);

        expect(OrderHistoryFinders.listWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display no orders message when state is [OrderHistoryLoaded] '
      'but orders list is empty',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((invocation) => const OrderHistoryLoaded([]));

        await pumpOrderHistoryScreen(tester);

        expect(OrderHistoryFinders.noOrdersWidget, findsOneWidget);
      },
    );

    testWidgets(
      'should display list of Orders when state is [OrderHistoryLoadingError]',
      (tester) async {
        when(() => orderHistoryCubit.state)
            .thenAnswer((_) => const OrderHistoryLoadingError('fake error'));

        await pumpOrderHistoryScreen(tester);

        expect(OrderHistoryFinders.errorWidget, findsOneWidget);
        expect(find.text('fake error'), findsOneWidget);
      },
    );
  });
}
