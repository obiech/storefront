import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/domain/services/product_search_service.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';
import 'test.ext.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');

  late SearchInventoryCubit cubit;
  late IProductSearchRepository repository;
  late SearchServiceClient searchServiceClient;

  setUp(() {
    searchServiceClient = MockSearchServiceClient();
    repository = ProductSearchService(searchServiceClient);
    cubit = SearchInventoryCubit(repository);

    registerFallbackValue(SearchInventoryRequest(query: 'susu'));
  });

  testWidgets('When stock is zero, gray out card', (WidgetTester tester) async {
    /// arrange
    const productId = '51d44faf';

    final SearchInventoryResponse inventoryResponse = SearchInventoryResponse(
      results: [
        SearchInventoryResult(
          productId: productId,
          name: 'milkuat cokelat malt uht 115ml  pcs',
          brand: 'milkuat',
          sku: 'sku0961',
          imageUrl: 'milkuatcokelatmaltuht115mlpcs.jpg',
          storeId: 'store_11',
          stock: 0,
        ),
      ],
    );

    when(() => searchServiceClient.searchInventory(any()))
        .thenAnswer((_) => MockResponseFuture.value(inventoryResponse));

    /// act
    await tester.pumpSearchResultsWidget(cubit);
    await cubit.searchInventory('susu');
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);

    final productItemFinder = find.byKey(const ValueKey('product_item0'));

    expect(productItemFinder, findsOneWidget);
    expect(
      find.descendant(
        of: productItemFinder,
        matching: find.byType(OutOfStockOverdraw),
      ),
      findsOneWidget,
    );
  });
}
