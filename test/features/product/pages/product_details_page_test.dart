import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product/domain/domain.dart';
import 'package:storefront_app/features/product/pages/product_details_page.dart';

import '../../../../test_commons/fixtures/product/product_models.dart';
import '../../../src/mock_navigator.dart';

void main() {
  const mockProductModel = seledaRomaine;

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  testWidgets(
      'show search page '
      'when search text field on app bar is tapped', (tester) async {
    final stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);

    await tester.pumpProductDetailsPage(
      mockProductModel,
      stackRouter: stackRouter,
    );

    final searchFieldFinder = find.byType(SearchTextField);
    expect(searchFieldFinder, findsOneWidget);

    final searchField = tester.firstWidget<SearchTextField>(
      searchFieldFinder,
    );

    /// Search field should be readonly
    expect(searchField.isEnabled, false);

    await tester.tap(searchFieldFinder);

    final capturedRoutes =
        verify(() => stackRouter.push(captureAny())).captured;

    expect(capturedRoutes.length, 1);
    expect(capturedRoutes.first, isA<GlobalSearchRoute>());
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductDetailsPage(
    ProductModel productModel, {
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: MaterialApp(
                home: Scaffold(
                  body: ProductDetailPage(
                    productModel: productModel,
                  ),
                ),
              ),
            )
          : MaterialApp(
              home: Scaffold(
                body: ProductDetailPage(
                  productModel: productModel,
                ),
              ),
            ),
    );
  }
}
