import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/order/domain/services/order_repository.dart';

import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    'OrderRepository',
    () {
      late OrderServiceClient orderServiceClient;
      late OrderRepository grpcOrderRepository;

      setUp(() {
        registerFallbackValue(GetOrderHistoryRequest());
        orderServiceClient = MockOrderServiceClient();
        grpcOrderRepository = OrderRepository(orderServiceClient);
      });

      group(
        '[getUserOrders()]',
        () {
          test(
            'should retrieve list of orders from [OrderServiceClient]',
            () async {
              //TODO (leovinsen): Add fake gRPC Orders once Mehmet's Proto
              // definitions are merged
              // arrange
              when(() => orderServiceClient.getOrderHistory(any())).thenAnswer(
                (_) => MockResponseFuture.value(
                  GetOrderHistoryResponse(
                    orders: [],
                  ),
                ),
              );

              // act
              final result = await grpcOrderRepository.getUserOrders();

              // assert
              verify(() => orderServiceClient.getOrderHistory(any())).called(1);
              expect(result.isRight(), true);
            },
          );

          test(
            'should map Exceptions to Failure',
            () async {
              // arrange
              when(() => orderServiceClient.getOrderHistory(any())).thenAnswer(
                (_) => MockResponseFuture.error(
                  GrpcError.notFound('User orders not found'),
                ),
              );

              // act
              final result = await grpcOrderRepository.getUserOrders();

              // assert
              verify(() => orderServiceClient.getOrderHistory(any())).called(1);
              result.fold(
                (l) {
                  expect(l, isA<NetworkFailure>());
                  expect(l.message, 'User orders not found');
                },
                (r) => throw TestFailure(
                  '[getUserOrders] failed to map exception into Failure',
                ),
              );
            },
          );
        },
      );
    },
  );
}
