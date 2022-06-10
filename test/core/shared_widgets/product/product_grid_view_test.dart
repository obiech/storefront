import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;
import '../../../../test_commons/utils/locale_setup.dart';
import '../../../src/mock_navigator.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductGridView({
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MaterialApp(
                home: Scaffold(
                  body: ProductGridView(
                    productModelList: fixtures.fakeCategoryProductList,
                    columns: 2,
                  ),
                ),
              ),
            )
          : MaterialApp(
              home: Scaffold(
                body: ProductGridView(
                  productModelList: fixtures.fakeCategoryProductList,
                  columns: 2,
                ),
              ),
            ),
    );
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  testWidgets('Should display a grid of [ProductItemCard]',
      (WidgetTester tester) async {
    await tester.pumpProductGridView();

    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byType(ProductItemCard, skipOffstage: false),
      findsNWidgets(fixtures.fakeCategoryProductList.length),
    );
  });

  testWidgets(
      'should move to product details '
      'when product card is tapped', (WidgetTester tester) async {
    /// arrange
    final stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);

    await tester.pumpProductGridView(stackRouter: stackRouter);

    /// act
    final productList = fixtures.fakeCategoryProductList;
    expect(
      find.byType(ProductItemCard, skipOffstage: false),
      findsNWidgets(productList.length),
    );

    for (int i = 0; i < productList.length; i++) {
      final _key = ValueKey('product_item$i');

      expect(find.byKey(_key), findsOneWidget);
      await tester.tap(find.byKey(_key));
    }

    /// Expect all cards to go tot product details page
    final capturedRoutes =
        verify(() => stackRouter.push(captureAny())).captured;
    expect(capturedRoutes.length, productList.length);

    for (int i = 0; i < capturedRoutes.length; i++) {
      expect(capturedRoutes[i], isA<ProductDetailRoute>());
      final route = capturedRoutes[i] as ProductDetailRoute;
      expect(route.args!.productModel, productList[i]);
    }
  });
}
