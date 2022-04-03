import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
              when(() => orderRepository.getUserOrders())
                  .thenAnswer((_) async => []);
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
            'throws an error',
            setUp: () {
              when(() => orderRepository.getUserOrders())
                  .thenThrow(Exception('fake error'));
            },
            build: () => createCubit(),
            act: (cubit) => cubit.fetchUserOrderHistory(),
            expect: () => [
              OrderHistoryLoading(),
              const OrderHistoryLoadingError('Error loading Order History'),
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
