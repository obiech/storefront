import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../test_commons/fixtures/product/product_models.dart';
import '../../../src/mock_navigator.dart';
import '../../cart_checkout/mocks.dart';

void main() {
  const mockProductModel = seledaRomaine;
  late CartBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    bloc = MockCartBloc();

    when(() => bloc.state).thenAnswer((_) => CartLoaded.success(mockCartModel));
  });

  testWidgets(
      'show search page '
      'when search text field on app bar is tapped', (tester) async {
    final stackRouter = MockStackRouter();
    when(() => stackRouter.push(any())).thenAnswer((_) async => null);

    await tester.pumpProductDetailsPage(
      bloc,
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

  testWidgets('should display a floating cart summary',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductDetailsPage(bloc, mockProductModel);

    /// assert
    expect(find.byType(CartSummary), findsOneWidget);
  });

  testWidgets('should display respective PDP widgets',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpProductDetailsPage(bloc, mockProductModel);

    /// assert
    expect(find.byType(ProductDetailPageHeader), findsOneWidget);
    expect(find.byType(ProductDetailsSubHeader), findsOneWidget);
    expect(find.byType(ProductDescription), findsOneWidget);
    expect(find.byType(VariantsList), findsOneWidget);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductDetailsPage(
    CartBloc bloc,
    ProductModel productModel, {
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      stackRouter != null
          ? StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: BlocProvider(
                create: (context) => bloc,
                child: MaterialApp(
                  home: Scaffold(
                    body: ProductDetailPage(
                      productModel: productModel,
                    ),
                  ),
                ),
              ),
            )
          : BlocProvider(
              create: (context) => bloc,
              child: MaterialApp(
                home: Scaffold(
                  body: ProductDetailPage(
                    productModel: productModel,
                  ),
                ),
              ),
            ),
    );
  }
}
