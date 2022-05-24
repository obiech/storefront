import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/pb_summary_response.dart';
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    '[CartService]',
    () {
      const mockStoreId = 'store-id-1';

      late CartServiceClient cartServiceClient;
      late CartService cartService;

      setUp(() {
        cartServiceClient = MockCartServiceClient();
        cartService = CartService(cartServiceClient);
      });

      group(
        '[loadCart()]',
        () {
          final mockRequest = SummaryRequest(storeId: mockStoreId);
          final mockResponse = mockSummary;

          test(
            'should call [CartServiceClient.summary()] once '
            'and then return cart session '
            'when [loadCart()] is called',
            () async {
              when(() => cartServiceClient.summary(mockRequest))
                  .thenAnswer((_) => MockResponseFuture.value(mockResponse));
              final result = await cartService.loadCart(mockStoreId);

              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockResponse));
            },
          );

          test(
            'should call [CartServiceClient.summary()] once '
            'and then return a Failure '
            'when [loadCart()] is called '
            'and [CartServiceClient.summary()] returns an error',
            () async {
              when(() => cartServiceClient.summary(mockRequest)).thenAnswer(
                (_) => MockResponseFuture.error(
                  GrpcError.unauthenticated('User is unauthenticated'),
                ),
              );
              final result = await cartService.loadCart(mockStoreId);

              final failure = result.getLeft();
              expect(failure.message, 'User is unauthenticated');
            },
          );
        },
      );
    },
  );
}
