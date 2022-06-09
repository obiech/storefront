import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/discovery/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../commons.dart';
import '../../fixtures.dart';
import '../../mocks.dart';
import 'test.ext.dart';

void main() {
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

  testWidgets('When loading, a shimmer is shown', (WidgetTester tester) async {
    when(() => searchInventoryBloc.state)
        .thenReturn(SearchingForItemInInventory());
    await tester.pumpSearchResultsWidget(
      searchInventoryBloc,
      discoveryCubit,
    );

    for (int i = 0; i < 5; i++) {
      await tester.pump();
    }

    expect(find.byType(ProductGridLoading), findsOneWidget);
  });

  testWidgets('When no state is available nothing is shown',
      (WidgetTester tester) async {
    when(() => searchInventoryBloc.state).thenReturn(SearchInventoryInitial());
    await tester.pumpSearchResultsWidget(searchInventoryBloc, discoveryCubit);

    expect(find.byType(SizedBox), findsNWidgets(1));
  });

  testWidgets(
      'When inventory items are available, show GridList  list of items',
      (WidgetTester tester) async {
    when(() => searchInventoryBloc.state)
        .thenReturn(const InventoryItemResults(pageInventory, mockStoreId));
    await tester.pumpSearchResultsWidget(searchInventoryBloc, discoveryCubit);

    expect(find.byType(GridView), findsOneWidget);

    final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
    expect(_productWidgets.length, pageInventory.length);
  });
}
