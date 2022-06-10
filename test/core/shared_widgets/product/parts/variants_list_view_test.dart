import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';
import 'package:storefront_app/features/product/index.dart';

import '../../../../../test_commons/fixtures/cart/cart_models.dart';
import '../../../../../test_commons/fixtures/product/product_models.dart';
import '../../../../../test_commons/test_commons.dart';
import '../../../../../test_commons/utils/locale_setup.dart';
import '../../../../features/cart_checkout/mocks.dart';

void main() {
  late CartBloc cartBloc;

  setUpAll(() {
    setUpLocaleInjection();
  });

  setUp(() {
    cartBloc = MockCartBloc();
  });

  tearDown(() {
    cartBloc.close();
  });

  const product = pomegranate;
  final cartModel = mockCartModel.copyWith(
    items: [
      CartItemModel(
        variant: product.variants.first,
        quantity: 3,
      )
    ],
  );

  testWidgets('should show all variants of a product',
      (WidgetTester tester) async {
    /// arrange
    when(() => cartBloc.state).thenReturn(const CartInitial());

    expect(product.variants.length > 1, true);
    await tester.pumpVariantsListView(product, cartBloc);

    /// assert
    final variantTiles =
        tester.widgetList<VariantTile>(find.byType(VariantTile)).toList();

    expect(variantTiles.length, product.variants.length);

    for (int index = 0; index < variantTiles.length; index++) {
      final VariantTile variantTile = variantTiles[index];
      expect(variantTile.variant, product.variants[index]);
    }
  });

  testWidgets(
      'should show variant quantity for active variants in cart '
      'and update variant quantity '
      'when quantity is changed', (WidgetTester tester) async {
    /// arrange
    when(() => cartBloc.state).thenReturn(CartLoaded.success(cartModel));

    expect(product.variants.length > 1, true);
    await tester.pumpVariantsListView(product, cartBloc);

    /// Active variant should display it's quantity with option to change
    final variantInCart = cartModel.items.first.variant;
    final variantQuantity = cartModel.items.first.quantity;
    final quantityChangerFinder = find.descendant(
      of: find.byKey(ValueKey('variant-${variantInCart.sku}')),
      matching: find.byType(QtyChanger),
    );

    expect(quantityChangerFinder, findsOneWidget);

    expect(
      find.descendant(
        of: quantityChangerFinder,
        matching: find.text(variantQuantity.toString()),
      ),
      findsOneWidget,
    );

    /// Increment quantity
    await tester.tap(find.byIcon(DropezyIcons.plus));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: quantityChangerFinder,
        matching: find.text((variantQuantity + 1).toString()),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'should display maximum product quantity warning '
      'when variant is incremented up to maximum quantity',
      (WidgetTester tester) async {
    /// arrange
    when(() => cartBloc.state).thenReturn(
      CartLoaded.success(
        cartModel.copyWith(
          items: [
            CartItemModel(
              variant: product.variants.first,
              quantity: 1,
            )
          ],
        ),
      ),
    );

    expect(product.variants.length > 1, true);
    final variants = List.of(product.variants);
    const maxQty = 2;
    variants[0] = variants[0].copyWith(maxQty: maxQty);
    final context = await tester.pumpVariantsListView(
      product.copyWith(variants: variants),
      cartBloc,
    );

    /// act
    expect(ProductWidgetFinders.incrementButtonFinder, findsOneWidget);
    await tester.tap(ProductWidgetFinders.incrementButtonFinder);
    await tester.pump();

    /// assert
    expect(find.text(context.res.strings.maximumQty(maxQty)), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpVariantsListView(
    ProductModel product,
    CartBloc cartBloc,
  ) async {
    late BuildContext ctx;
    await pumpWidget(
      BlocProvider(
        create: (context) => cartBloc,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return VariantsListView(
                  product: product,
                );
              },
            ),
          ),
        ),
      ),
    );

    return ctx;
  }
}
