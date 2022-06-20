import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../commons.dart';
import '../../../cart_checkout/mocks.dart';
import '../../fixtures.dart';
import '../../mocks.dart';
import 'test.ext.dart';

void main() {
  late SearchInventoryBloc searchInventoryBloc;
  late CartBloc cartBloc;

  setUp(() {
    searchInventoryBloc = MockSearchInventoryBloc();
    cartBloc = MockCartBloc();

    when(() => cartBloc.state)
        .thenAnswer((_) => CartLoaded.success(mockCartModel));
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('When loading, a shimmer is shown', (WidgetTester tester) async {
    when(() => searchInventoryBloc.state)
        .thenReturn(SearchingForItemInInventory());
    await tester.pumpSearchResultsWidget(
      searchInventoryBloc,
      cartBloc,
    );

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ProductGridLoading), findsOneWidget);
  });

  testWidgets('When no state is available nothing is shown',
      (WidgetTester tester) async {
    when(() => searchInventoryBloc.state).thenReturn(SearchInventoryInitial());
    await tester.pumpSearchResultsWidget(searchInventoryBloc, cartBloc);

    expect(find.byType(SizedBox), findsNWidgets(1));
  });

  testWidgets(
      'When inventory items are available, show GridList  list of items',
      (WidgetTester tester) async {
    when(() => searchInventoryBloc.state)
        .thenReturn(const InventoryItemResults(pageInventory));
    await tester.pumpSearchResultsWidget(searchInventoryBloc, cartBloc);

    expect(find.byType(GridView), findsOneWidget);

    final _productWidgets = tester.widgetList(find.byType(ProductItemCard));
    expect(_productWidgets.length, pageInventory.length);
  });
}
