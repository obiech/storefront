import 'package:dropezy_proto/v1/inventory/inventory.pb.dart';
import 'package:dropezy_proto/v1/search/search.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/discovery/blocs/discovery/discovery_cubit.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../commons.dart';
import '../../mocks.dart';
import 'test.ext.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');

  const mockStoreId = 'store-id-1';

  late SearchInventoryBloc searchInventoryBloc;
  late DiscoveryCubit discoveryCubit;

  setUp(() {
    searchInventoryBloc = MockSearchInventoryBloc();
    discoveryCubit = MockDiscoveryCubit();
    when(() => discoveryCubit.state).thenReturn(mockStoreId);
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('When stock is zero, gray out card', (WidgetTester tester) async {
    /// arrange
    const productId = '51d44faf';

    final SearchInventoryResponse inventoryResponse = SearchInventoryResponse(
      results: [
        SearchInventoryResult(
          productId: productId,
          name: 'milkuat cokelat malt uht 115ml  pcs',
          brandName: 'milkuat',
          description: 'Dummy description',
          imagesUrls: ['milkuatcokelatmaltuht115mlpcs.jpg'],
          storeId: 'store_11',
          variants: [
            Variant(
              variantId: 'variant-id',
              imagesUrls: ['milkuatcokelatmaltuht115mlpcs.jpg'],
              variantQuantifier: 'ml',
              variantValue: '500 ml',
              name: '500 ml',
              sku: 'sku-000',
              stock: 0,
            )
          ],
        ),
      ],
    );

    when(() => searchInventoryBloc.state).thenReturn(
      InventoryItemResults(
        inventoryResponse.results.toModel,
        mockStoreId,
      ),
    );

    /// act
    await tester.pumpSearchResultsWidget(searchInventoryBloc, discoveryCubit);
    searchInventoryBloc.add(SearchInventory('susu', mockStoreId));

    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 400));

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
  });
}
