import 'package:dropezy_proto/v1/inventory/inventory.pbgrpc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/product/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../../test_commons/fixtures/product/product_inventory_models.dart'
    as pb_inventories;
import '../../../../src/mock_customer_service_client.dart';
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group('[ProductInventoryRepository]', () {
    late InventoryServiceClient client;
    late ProductInventoryRepository repository;
    late IStoreRepository storeRepository;

    int expectedLength = 0;
    final List<ProductModel> expectedProducts = [];
    const storeId = 'dummy-store-id';

    setUpAll(() {
      registerFallbackValue(GetRequest(categoryId: '1'));
      client = MockInventoryServiceClient();
      storeRepository = MockStoreRepository();
      repository = ProductInventoryRepository(client, storeRepository);

      dotenv.testLoad(fileInput: '''ASSETS_URL=https://test.dropezy.com''');

      for (final inventory in pb_inventories.fakeInventories) {
        final products = inventory.products.map(ProductModel.fromPb).toList();
        expectedLength += inventory.products.length;
        expectedProducts.addAll(products);
      }

      /// Store
      when(() => storeRepository.storeStream)
          .thenAnswer((_) => BehaviorSubject.seeded(storeId));
    });

    group('[getProductByCategory()]', () {
      test(
          'Should retrieve a list of inventories from [InventoryServiceClient] '
          'when [InventoryServiceClient] called', () async {
        when(
          () => client.get(
            GetRequest(
              storeId: storeId,
              categoryId: '1',
            ),
          ),
        ).thenAnswer(
          (_) => MockResponseFuture.value(
            GetResponse(
              inventories: pb_inventories.fakeInventories,
            ),
          ),
        );

        final result = await repository.getProductByCategory('1');

        verify(
          () => client.get(
            GetRequest(storeId: storeId, categoryId: '1'),
          ),
        ).called(1);

        expect(result.isRight(), true);

        final products = result.getRight();

        expect(products.length, expectedLength);
        expect(products, expectedProducts);
      });

      test(
        'should map Exceptions to Failure '
        'when a [NetworkFailure] is occurred',
        () async {
          when(
            () => client.get(
              GetRequest(storeId: storeId, categoryId: '1'),
            ),
          ).thenAnswer(
            (_) => MockResponseFuture.error(
              GrpcError.notFound('Products not found'),
            ),
          );

          final result = await repository.getProductByCategory('1');

          verify(
            () => client.get(
              GetRequest(storeId: storeId, categoryId: '1'),
            ),
          ).called(1);

          expect(result.isLeft(), true);

          final failure = result.getLeft();

          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'Products not found');
        },
      );
    });
  });
}
