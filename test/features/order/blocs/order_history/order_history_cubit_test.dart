import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/errors/_exporter.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../mocks.dart';

void main() {
  late IOrderRepository orderRepository;

  OrderHistoryCubit createCubit() {
    return OrderHistoryCubit(orderRepository);
  }

  setUp(() {
    orderRepository = MockOrderRepository();
  });
  group(
    '[OrderHistoryCubit]',
    () {
      test(
        'initial state should be [OrderHistoryInitial]',
        () {
          final orderHistoryCubit = createCubit();

          expect(orderHistoryCubit.state, OrderHistoryInitial());
        },
      );

      group(
        '[fetchUserOrderHistory()] emits [OrderHistoryLoading] followed by',
        () {
          blocTest<OrderHistoryCubit, OrderHistoryState>(
            '[OrderHistoryLoaded] with result from '
            '[orderRepository.getUserOrders()]',
            setUp: () {
              when(() => orderRepository.getUserOrders()).thenAnswer(
                (_) async => right([]),
              );
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchUserOrderHistory(),
            expect: () => [
              OrderHistoryLoading(),
              const OrderHistoryLoaded([]),
            ],
            verify: (cubit) {
              verify(() => orderRepository.getUserOrders()).called(1);
            },
          );

          blocTest<OrderHistoryCubit, OrderHistoryState>(
            '[OrderHistoryLoadingError] if [orderRepository.getUserOrders()] '
            'returns a failure',
            setUp: () {
              when(() => orderRepository.getUserOrders()).thenAnswer(
                (_) async => left(
                  Failure('Failed to load order history'),
                ),
              );
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchUserOrderHistory(),
            expect: () => [
              OrderHistoryLoading(),
              const OrderHistoryLoadingError('Failed to load order history'),
            ],
            verify: (cubit) {
              verify(() => orderRepository.getUserOrders()).called(1);
            },
          );
        },
      );
    },
  );
}
