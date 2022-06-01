import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../test_commons/fixtures/cart/pb_summary_response.dart';
import '../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    '[CartService]',
    () {
      const mockStoreId = 'store-id-1';
      const mockVariant = variant_fixtures.variantMango;
      final mockSummaryRequest = SummaryRequest(storeId: mockStoreId);
      final mockSummaryResponse = mockSummary;

      late CartServiceClient cartServiceClient;
      late CartService cartService;

      setUp(() {
        cartServiceClient = MockCartServiceClient();
        cartService = CartService(cartServiceClient);
      });

      group(
        '[loadCart()]',
        () {
          test(
            'should call [CartServiceClient.summary()] once '
            'and then return cart session '
            'when [loadCart()] is called',
            () async {
              // arrange
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.loadCart(mockStoreId);

              // assert
              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockSummaryResponse));

              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );

          test(
            'should call [CartServiceClient.summary()] once '
            'and then return a Failure '
            'when [loadCart()] is called '
            'and [CartServiceClient.summary()] returns an error',
            () async {
              // arrange
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.error(
                  GrpcError.unauthenticated('User is unauthenticated'),
                ),
              );

              // act
              final result = await cartService.loadCart(mockStoreId);

              // assert
              final failure = result.getLeft();
              expect(failure.message, 'User is unauthenticated');

              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );
        },
      );

      group(
        '[addItem()]',
        () {
          final mockRequest = AddRequest(
            storeId: mockStoreId,
            item: UpdateItem(variantId: mockVariant.id),
          );

          test(
            'should call [CartServiceClient.addItem()] once '
            'and call [loadCart()] once '
            'and return cart session '
            'when [addItem()] is called',
            () async {
              // arrange
              when(() => cartServiceClient.add(mockRequest)).thenAnswer(
                (_) => MockResponseFuture.value(AddResponse()),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.addItem(
                mockRequest.storeId,
                mockVariant,
              );

              // assert
              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockSummaryResponse));

              verify(() => cartServiceClient.add(mockRequest)).called(1);
              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );

          test(
            'should call [CartServiceClient.addItem()] once '
            'and return a failure '
            'when [addItem()] is called '
            'and [CartServiceClient.addItem()] throws an exception',
            () async {
              // arrange
              when(() => cartServiceClient.add(mockRequest)).thenAnswer(
                (_) =>
                    MockResponseFuture.error(GrpcError.notFound('Test Error')),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.addItem(
                mockRequest.storeId,
                mockVariant,
              );

              // assert
              final failure = result.getLeft();
              expect(failure, isA<Failure>());
              expect(failure.message, 'Test Error');

              verify(() => cartServiceClient.add(mockRequest)).called(1);
              verifyNever(() => cartServiceClient.summary(mockSummaryRequest));
            },
          );
        },
      );
    },
  );
}
