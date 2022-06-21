import 'package:dropezy_proto/v1/cart/cart.pbgrpc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/discovery/index.dart';

import '../../../../../test_commons/fixtures/cart/pb_summary_response.dart';
import '../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
import '../../../../commons.dart';
import '../../../../src/mock_customer_service_client.dart';
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  setupFirebaseCrashlyticsMocks();
  group(
    '[CartService]',
    () {
      const mockStoreId = 'store-id-1';
      const mockVariant = variant_fixtures.variantMango;
      final mockSummaryRequest = SummaryRequest(storeId: mockStoreId);
      final mockSummaryResponse = mockSummary;

      late CartServiceClient cartServiceClient;
      late CartService cartService;
      late IStoreRepository storeRepository;

      setUp(() {
        cartServiceClient = MockCartServiceClient();
        storeRepository = MockStoreRepository();
        cartService = CartService(cartServiceClient, storeRepository);

        // Store
        when(() => storeRepository.activeStoreId)
            .thenAnswer((_) => mockStoreId);
      });

      setUpAll(() async {
        await Firebase.initializeApp();
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
              final result = await cartService.loadCart();

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
              final result = await cartService.loadCart();

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
            item: UpdateItem(
              variantId: mockVariant.id,
              quantity: 1,
            ),
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
              final result = await cartService.addItem(mockVariant);

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

      group(
        '[incrementItem()]',
        () {
          const mockQty = 3;
          final mockRequest = UpdateRequest(
            storeId: mockStoreId,
            item: UpdateItem(
              variantId: mockVariant.id,
              quantity: mockQty,
            ),
            action: UpdateAction.UPDATE_ACTION_ADD,
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and call [loadCart()] once '
            'and return cart session '
            'when [incrementItem()] is called',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) => MockResponseFuture.value(UpdateResponse()),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.incrementItem(
                mockVariant,
                mockQty,
              );

              // assert
              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockSummaryResponse));

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and return a failure '
            'when [incrementItem()] is called '
            'and [CartServiceClient.update()] throws an exception',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) =>
                    MockResponseFuture.error(GrpcError.notFound('Test Error')),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.incrementItem(
                mockVariant,
                mockQty,
              );

              // assert
              final failure = result.getLeft();
              expect(failure, isA<Failure>());
              expect(failure.message, 'Test Error');

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verifyNever(() => cartServiceClient.summary(mockSummaryRequest));
            },
          );
        },
      );

      group(
        '[decrementItem()]',
        () {
          const mockQty = 3;
          final mockRequest = UpdateRequest(
            storeId: mockStoreId,
            item: UpdateItem(
              variantId: mockVariant.id,
              quantity: mockQty,
            ),
            action: UpdateAction.UPDATE_ACTION_SUBSTRACT,
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and call [loadCart()] once '
            'and return cart session '
            'when [decrementItem()] is called',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) => MockResponseFuture.value(UpdateResponse()),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.decrementItem(
                mockVariant,
                mockQty,
              );

              // assert
              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockSummaryResponse));

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and return a failure '
            'when [decrementItem()] is called '
            'and [CartServiceClient.update()] throws an exception',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) =>
                    MockResponseFuture.error(GrpcError.notFound('Test Error')),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.decrementItem(
                mockVariant,
                mockQty,
              );

              // assert
              final failure = result.getLeft();
              expect(failure, isA<Failure>());
              expect(failure.message, 'Test Error');

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verifyNever(() => cartServiceClient.summary(mockSummaryRequest));
            },
          );
        },
      );

      group(
        '[removeItem()]',
        () {
          final mockRequest = UpdateRequest(
            storeId: mockStoreId,
            item: UpdateItem(
              variantId: mockVariant.id,
              quantity: 1,
            ),
            action: UpdateAction.UPDATE_ACTION_REMOVE,
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and call [loadCart()] once '
            'and return cart session '
            'when [removeItem()] is called',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) => MockResponseFuture.value(UpdateResponse()),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.removeItem(
                mockVariant,
              );

              // assert
              final cart = result.getRight();
              expect(cart, CartModel.fromPb(mockSummaryResponse));

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verify(() => cartServiceClient.summary(mockSummaryRequest))
                  .called(1);
            },
          );

          test(
            'should call [CartServiceClient.update()] once '
            'and return a failure '
            'when [removeItem()] is called '
            'and [CartServiceClient.update()] throws an exception',
            () async {
              // arrange
              when(() => cartServiceClient.update(mockRequest)).thenAnswer(
                (_) =>
                    MockResponseFuture.error(GrpcError.notFound('Test Error')),
              );
              when(() => cartServiceClient.summary(mockSummaryRequest))
                  .thenAnswer(
                (_) => MockResponseFuture.value(mockSummaryResponse),
              );

              // act
              final result = await cartService.removeItem(
                mockVariant,
              );

              // assert
              final failure = result.getLeft();
              expect(failure, isA<Failure>());
              expect(failure.message, 'Test Error');

              verify(() => cartServiceClient.update(mockRequest)).called(1);
              verifyNever(() => cartServiceClient.summary(mockSummaryRequest));
            },
          );
        },
      );
    },
  );
}
