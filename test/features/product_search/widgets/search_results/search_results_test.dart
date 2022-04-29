import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/index.dart';
import 'package:storefront_app/features/product_search/widgets/search_results/search_results_loading.dart';

import '../../fixtures.dart';
import '../../mocks.dart';
import 'test.ext.dart';

void main() {
  late SearchInventoryBloc searchInventoryBloc;
  late IProductSearchRepository repository;
  late ISearchHistoryRepository searchHistoryRepository;

  setUp(() {
    repository = MockProductSearchRepository();
    searchHistoryRepository = MockSearchHistoryRepository();

    searchInventoryBloc =
        SearchInventoryBloc(repository, searchHistoryRepository);
  });

  testWidgets('When loading, a shimmer is shown', (WidgetTester tester) async {
    searchInventoryBloc.emit(SearchingForItemInInventory());
    await tester.pumpSearchResultsWidget(searchInventoryBloc);

    for (int i = 0; i < 5; i++) {
      await tester.pump();
    }

    expect(find.byType(SearchResultsLoading), findsOneWidget);
  });

  testWidgets('When no state is available nothing is shown',
      (WidgetTester tester) async {
    searchInventoryBloc.emit(SearchInventoryInitial());
    await tester.pumpSearchResultsWidget(searchInventoryBloc);

    expect(find.byType(SizedBox), findsNWidgets(1));
  });

  testWidgets(
      'When inventory items are available, show GridList  list of items',
      (WidgetTester tester) async {
    searchInventoryBloc.emit(const InventoryItemResults(pageInventory));
    await tester.pumpSearchResultsWidget(searchInventoryBloc);

    expect(find.byType(GridView), findsOneWidget);

    final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
    expect(_productWidgets.length, pageInventory.length);
  });
}
