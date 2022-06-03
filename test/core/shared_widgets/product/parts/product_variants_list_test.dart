import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/fixtures/product/product_models.dart';
import '../../../../features/cart_checkout/mocks.dart';

void main() {
  late CartBloc cartBloc;
  const product = pomegranate;

  setUp(() {
    cartBloc = MockCartBloc();
    when(() => cartBloc.state).thenReturn(CartLoaded.success(mockCartModel));
  });

  tearDown(() {
    cartBloc.close();
  });

  testWidgets('should display product name', (WidgetTester tester) async {
    /// arrange
    await tester.pumpVariantsListView(product, cartBloc);

    /// assert
    expect(find.text(product.name), findsOneWidget);
  });

  testWidgets('should display [VariantsListView]', (WidgetTester tester) async {
    /// arrange
    await tester.pumpVariantsListView(product, cartBloc);

    /// assert
    expect(find.byType(VariantsListView), findsOneWidget);

    final variantListView =
        tester.firstWidget<VariantsListView>(find.byType(VariantsListView));

    expect(variantListView.product, product);
  });

  testWidgets('should display [CartSummary]', (WidgetTester tester) async {
    /// arrange
    await tester.pumpVariantsListView(product, cartBloc);

    /// assert
    expect(find.byType(CartSummary), findsOneWidget);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpVariantsListView(
    ProductModel product,
    CartBloc cartBloc,
  ) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => cartBloc,
        child: MaterialApp(
          home: Scaffold(
            body: ProductVariantsList(
              product: product,
            ),
          ),
        ),
      ),
    );
  }
}
