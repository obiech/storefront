import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/index.dart';

import '../../../../../test_commons/fixtures/order/order_models.dart';
import '../../pages/order_details/mock.dart';

void main() {
  late IOrderRepository repository;

  OrderDetailsCubit createCubit() {
    return OrderDetailsCubit(repository);
  }

  setUp(() {
    repository = MockIOrderRepository();
  });

  group('[OrderDetailsCubit]', () {
    test('Initial state should be [InitialOrderDetails]', () {
      final orderDetailsCubit = createCubit();
      expect(orderDetailsCubit.state, InitialOrderDetails());
    });

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'Should show [LoadedOrderDetails] with order from '
      '[IOrderRepository.getOrderById()]',
      setUp: () {
        when(() => repository.getOrderById(orderAwaitingPayment.id)).thenAnswer(
          (_) async => right(orderAwaitingPayment),
        );
      },
      build: () => createCubit(),
      act: (cubit) => cubit.getUserOrderDetails(orderAwaitingPayment.id),
      expect: () => [
        LoadingOrderDetails(),
        LoadedOrderDetails(orderAwaitingPayment),
      ],
      verify: (cubit) {
        verify(() => repository.getOrderById(orderAwaitingPayment.id))
            .called(1);
      },
    );

    blocTest<OrderDetailsCubit, OrderDetailsState>(
      'Should show [LoadingErrorOrderDetails] '
      'when [IOrderRepository.getOrderById()] return failure',
      setUp: () {
        when(() => repository.getOrderById(orderAwaitingPayment.id)).thenAnswer(
          (_) async => left(Failure('An unexpected error occured.')),
        );
      },
      build: () => createCubit(),
      act: (cubit) => cubit.getUserOrderDetails(orderAwaitingPayment.id),
      expect: () => [
        LoadingOrderDetails(),
        const LoadingErrorOrderDetails('An unexpected error occured.'),
      ],
      verify: (cubit) {
        verify(() => repository.getOrderById(orderAwaitingPayment.id))
            .called(1);
      },
    );

    for (int x = 0; x < refreshOrderList.length; x++) {
      blocTest<OrderDetailsCubit, OrderDetailsState>(
        'Should refresh [LoadedOrderDetails] when status is  ${refreshOrderList[x].status}',
        setUp: () {
          when(() => repository.getOrderById(orderAwaitingPayment.id))
              .thenAnswer(
            (_) async => right(orderAwaitingPayment),
          );
        },
        build: () => createCubit(),
        act: (cubit) async {
          cubit.getUserOrderDetails(orderAwaitingPayment.id);
        },
        wait: const Duration(seconds: 17),
        expect: () => [
          LoadingOrderDetails(),
          LoadedOrderDetails(orderAwaitingPayment),
          LoadingOrderDetails(),
          LoadedOrderDetails(orderAwaitingPayment),
        ],
        verify: (cubit) {
          verify(() => repository.getOrderById(orderAwaitingPayment.id))
              .called(2);
        },
      );
    }

    for (int x = 0; x < notRefreshOrderList.length; x++) {
      blocTest<OrderDetailsCubit, OrderDetailsState>(
        'Should not refresh [LoadedOrderDetails] when status is ${notRefreshOrderList[x].status}',
        setUp: () {
          when(() => repository.getOrderById(notRefreshOrderList[x].id))
              .thenAnswer(
            (_) async => right(notRefreshOrderList[x]),
          );
        },
        build: () => createCubit(),
        act: (cubit) async {
          cubit.getUserOrderDetails(notRefreshOrderList[x].id);
        },
        wait: const Duration(seconds: 17),
        expect: () => [
          LoadingOrderDetails(),
          LoadedOrderDetails(notRefreshOrderList[x]),
        ],
        verify: (cubit) {
          verify(() => repository.getOrderById(notRefreshOrderList[x].id))
              .called(1);
        },
      );
    }
  });
}
