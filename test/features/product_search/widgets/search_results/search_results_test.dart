import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/index.dart';
import 'package:storefront_app/features/product_search/widgets/search_results/search_results_loading.dart';

import '../../fixtures.dart';
import '../../mocks.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSearchResultsWidget(SearchInventoryCubit cubit) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => cubit,
        child: const MaterialApp(
          home: Scaffold(
            body: SearchResults(),
          ),
        ),
      ),
    );
  }
}

void main() {
  late SearchInventoryCubit cubit;
  late IProductSearchRepository repository;

  setUp(() {
    repository = MockProductSearchRepository();
    cubit = SearchInventoryCubit(repository);
  });

  testWidgets('When loading, a shimmer is shown', (WidgetTester tester) async {
    cubit.emit(SearchingForItemInInventory());
    await tester.pumpSearchResultsWidget(cubit);

    for (int i = 0; i < 5; i++) {
      await tester.pump();
    }

    expect(find.byType(SearchResultsLoading), findsOneWidget);
  });

  testWidgets('When no state is available nothing is shown',
      (WidgetTester tester) async {
    cubit.emit(SearchInventoryInitial());
    await tester.pumpSearchResultsWidget(cubit);

    expect(find.byType(SizedBox), findsNWidgets(1));
  });

  testWidgets(
      'When inventory items are available, show GridList  list of items',
      (WidgetTester tester) async {
    cubit.emit(const InventoryItemResults(pageInventory));
    await tester.pumpSearchResultsWidget(cubit);

    expect(find.byType(GridView), findsOneWidget);

    final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
    expect(_productWidgets.length, pageInventory.length);
  });
}
