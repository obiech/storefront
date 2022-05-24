import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/domain/models/order_model.dart';
import 'package:storefront_app/features/order/domain/services/order_repository.dart';

import '../../../../../test_commons/fixtures/order/order_pb_models.dart'
    as pb_orders;
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    'OrderRepository',
    () {
      late OrderServiceClient orderServiceClient;
      late OrderRepository grpcOrderRepository;

      final mockPbOrders = [
        pb_orders.orderCreated,
        pb_orders.orderPaid,
        pb_orders.orderDone,
      ];

      setUp(() {
        registerFallbackValue(GetOrderHistoryRequest());
        registerFallbackValue(GetRequest());
        orderServiceClient = MockOrderServiceClient();
        grpcOrderRepository = OrderRepository(orderServiceClient);
      });

      group('[getUserOrders()]', () {
        test(
          'should retrieve list of orders from [OrderServiceClient] '
          'and store them in memory',
          () async {
            // ARRANGE
            when(() => orderServiceClient.getOrderHistory(any())).thenAnswer(
              (_) => MockResponseFuture.value(
                GetOrderHistoryResponse(
                  orders: mockPbOrders,
                ),
              ),
            );

            // memory cache should be initially empty
            expect(grpcOrderRepository.orders, isEmpty);

            // ACT
            final result = await grpcOrderRepository.getUserOrders();

            // ASSERT
            verify(() => orderServiceClient.getOrderHistory(any())).called(1);

            final orders = result.getRight();

            // results should be of valid format
            expect(
              orders,
              mockPbOrders.map(OrderModel.fromPb).toList(),
            );

            // results should be stored in memory
            expect(grpcOrderRepository.orders, isNotEmpty);
            expect(orders, grpcOrderRepository.orders);
          },
        );

        test(
          'should map Exceptions to Failure',
          () async {
            // ARRANGE
            when(() => orderServiceClient.getOrderHistory(any())).thenAnswer(
              (_) => MockResponseFuture.error(
                GrpcError.notFound('User orders not found'),
              ),
            );

            // ACT
            final result = await grpcOrderRepository.getUserOrders();

            // ASSERT
            verify(() => orderServiceClient.getOrderHistory(any())).called(1);

            final failure = result.getLeft();
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, 'User orders not found');
          },
        );
      });

      group(
        '[getOrderById]',
        () {
          test(
            'should fetch from memory if an order with requested id exists',
            () async {
              // ARRANGE
              grpcOrderRepository.orders =
                  mockPbOrders.map(OrderModel.fromPb).toList();

              // ACT
              final result = await grpcOrderRepository
                  .getOrderById(grpcOrderRepository.orders[0].id);

              // ASSERT
              // should not fetch from gRPC service
              verifyNever(() => orderServiceClient.get(any()));

              final order = result.getRight();

              // returned order should be same as the one in memory
              expect(order, grpcOrderRepository.orders[0]);
            },
          );

          test(
            'should fetch from backend if an order with requested id '
            'does not exist in memory',
            () async {
              // ARRANGE
              final mockPbOrder = mockPbOrders[0];
              when(
                () => orderServiceClient
                    .get(GetRequest(orderId: mockPbOrder.orderId)),
              ).thenAnswer(
                (_) => MockResponseFuture.value(
                  GetResponse(order: mockPbOrder),
                ),
              );

              // ACT
              final result =
                  await grpcOrderRepository.getOrderById(mockPbOrder.orderId);

              // ASSERT
              // should fetch from gRPC service
              verify(() => orderServiceClient.get(any())).called(1);

              final order = result.getRight();
              expect(order, OrderModel.fromPb(mockPbOrder));
            },
          );

          test(
            'should map Exceptions to Failure',
            () async {
              // ARRANGE
              const String mockErrorMsg = 'Order not found';

              when(
                () => orderServiceClient.get(any()),
              ).thenAnswer(
                (_) => MockResponseFuture.error(
                  GrpcError.notFound(mockErrorMsg),
                ),
              );

              // ACT
              final result = await grpcOrderRepository.getOrderById('order-id');

              // ASSERT
              // should fetch from gRPC service
              verify(() => orderServiceClient.get(any())).called(1);

              final failure = result.getLeft();
              expect(failure, isA<NetworkFailure>());
              expect(failure.message, mockErrorMsg);
            },
          );
        },
      );
    },
  );
}
