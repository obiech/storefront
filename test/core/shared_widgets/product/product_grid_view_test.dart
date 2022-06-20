import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../test_commons/fixtures/product/product_models.dart'
    as fixtures;
import '../../../../test_commons/utils/locale_setup.dart';
import '../../../features/cart_checkout/mocks.dart';
import '../../../src/mock_navigator.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductGridView(
    CartBloc cartBloc, {
    StackRouter? stackRouter,
  }) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => cartBloc,
        child: MaterialApp(
          home: Scaffold(
            body: ProductGridView(
              productModelList: fixtures.fakeCategoryProductList,
              columns: 2,
            ),
          ),
        ),
      ).withRouterScope(stackRouter),
    );
  }
}

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = MockCartBloc();

    when(() => cartBloc.state)
        .thenAnswer((_) => CartLoaded.success(mockCartModel));
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  testWidgets('Should display a grid of [ProductItemCard]',
      (WidgetTester tester) async {
    await tester.pumpProductGridView(cartBloc);

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

    await tester.pumpProductGridView(cartBloc, stackRouter: stackRouter);

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
