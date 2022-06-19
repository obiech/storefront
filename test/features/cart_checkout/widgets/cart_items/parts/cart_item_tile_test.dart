import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

import '../../../../../../test_commons/fixtures/product/variant_models.dart'
    as variant_fixtures;
import '../../../../../commons.dart';
import '../../../mocks.dart';

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    '[CartItemTile]',
    () {
      late CartItemModel cartItemInStock;
      late CartItemModel cartItemMaxOrder;
      late CartItemModel cartItemOutOfStock;
      late CartBloc cartBloc;

      setUpAll(() {
        cartItemInStock = CartItemModel(
          variant: variant_fixtures.variantMango.copyWith(stock: 10),
          quantity: 5,
        );
        cartItemMaxOrder = CartItemModel(
          variant: variant_fixtures.variantMango.copyWith(
            stock: 10,
            maxQty: 6,
          ),
          quantity: 5,
        );
        cartItemOutOfStock = CartItemModel(
          variant: variant_fixtures.variantMango.copyWith(stock: 0),
          quantity: 5,
        );
        cartBloc = MockCartBloc();
      });

      group(
        'cart item is in stock',
        () {
          testWidgets(
            'should show [QtyChanger] '
            'when cart item is in stock',
            (WidgetTester tester) async {
              await tester.pumpCartItemTile(
                item: cartItemInStock,
                cartBloc: cartBloc,
              );

              final variantId = cartItemInStock.variant.id;
              final finderQtyChanger =
                  find.byKey(CartItemsSectionKeys.qtyChanger(variantId));
              final finderDeleteButton =
                  find.byKey(CartItemsSectionKeys.deleteButton(variantId));

              expect(finderQtyChanger, findsOneWidget);
              expect(finderDeleteButton, findsNothing);
            },
          );

          testWidgets(
            'should increment quantity '
            'and send a EditCartEvent with new quantity '
            'when plus button is tapped',
            (WidgetTester tester) async {
              await tester.pumpCartItemTile(
                item: cartItemInStock,
                cartBloc: cartBloc,
              );

              final originalQty = cartItemInStock.quantity;
              final newQty = originalQty + 1;
              final finderPlusButton = find.byIcon(DropezyIcons.plus);

              // assert original qty is shown
              expect(find.text(originalQty.toString()), findsOneWidget);

              await tester.tap(finderPlusButton);
              await tester.pumpAndSettle();

              // assert qty has changed, and an EditCartItem evet is dispatched
              expect(find.text(newQty.toString()), findsOneWidget);
              verify(
                () => cartBloc.add(
                  EditCartItem(cartItemInStock.variant, newQty),
                ),
              ).called(1);
            },
          );

          testWidgets(
            'should decrement quantity '
            'and send a EditCartEvent with new quantity '
            'when minus button is tapped',
            (WidgetTester tester) async {
              await tester.pumpCartItemTile(
                item: cartItemInStock,
                cartBloc: cartBloc,
              );

              final originalQty = cartItemInStock.quantity;
              final newQty = originalQty - 1;
              final finderMinusButton = find.byIcon(DropezyIcons.minus);

              // assert original qty is shown
              expect(find.text(originalQty.toString()), findsOneWidget);

              await tester.tap(finderMinusButton);
              await tester.pumpAndSettle();

              // assert qty has changed, and an EditCartItem event is dispatched
              expect(find.text(newQty.toString()), findsOneWidget);

              verify(
                () => cartBloc.add(
                  EditCartItem(cartItemInStock.variant, newQty),
                ),
              ).called(1);
            },
          );

          testWidgets(
            'should show a Maximum Order warning message '
            'when plus button is tapped '
            'and maximum order quantity is reached ',
            (WidgetTester tester) async {
              // arrange
              final ctx = await tester.pumpCartItemTile(
                item: cartItemMaxOrder,
                cartBloc: cartBloc,
              );

              final originalQty = cartItemMaxOrder.quantity;
              final newQty = originalQty + 1;
              final finderPlusButton = find.byIcon(DropezyIcons.plus);

              // act
              await tester.tap(finderPlusButton);
              await tester.pumpAndSettle();

              // assert
              expect(find.text(newQty.toString()), findsOneWidget);
              expect(
                find.text(
                  ctx.res.strings.maximumQty(cartItemMaxOrder.variant.maxQty!),
                ),
                findsOneWidget,
              );
              verify(
                () => cartBloc.add(
                  EditCartItem(cartItemMaxOrder.variant, newQty),
                ),
              ).called(1);
            },
          );

          testWidgets(
            'should remove Maximum Order warning message '
            'when minus button is tapped '
            'and maximum order quantity is currently shown ',
            (WidgetTester tester) async {
              // arrange
              final cartItem = cartItemMaxOrder.copyWith(quantity: 6);
              final ctx = await tester.pumpCartItemTile(
                item: cartItem,
                cartBloc: cartBloc,
              );

              final originalQty = cartItem.quantity;
              final newQty = originalQty - 1;
              final finderMinusButton = find.byIcon(DropezyIcons.minus);

              // act
              await tester.tap(finderMinusButton);
              await tester.pumpAndSettle();

              // assert
              expect(find.text(newQty.toString()), findsOneWidget);
              expect(
                find.text(
                  ctx.res.strings.maximumQty(cartItem.variant.maxQty!),
                ),
                findsNothing,
              );
              verify(
                () => cartBloc.add(
                  EditCartItem(cartItem.variant, newQty),
                ),
              ).called(1);
            },
          );
        },
      );

      group(
        'when cart item is out of stock',
        () {
          testWidgets(
            'should show "Delete" Button ',
            (WidgetTester tester) async {
              await tester.pumpCartItemTile(
                item: cartItemOutOfStock,
                cartBloc: cartBloc,
              );

              final variantId = cartItemOutOfStock.variant.id;

              final finderQtyChanger =
                  find.byKey(CartItemsSectionKeys.qtyChanger(variantId));

              final finderDeleteButton =
                  find.byKey(CartItemsSectionKeys.deleteButton(variantId));

              expect(finderQtyChanger, findsNothing);
              expect(finderDeleteButton, findsOneWidget);
            },
          );

          testWidgets(
            'should send a [RemoveCartItem] '
            'when "Delete" Button is tapped',
            (tester) async {
              await tester.pumpCartItemTile(
                item: cartItemOutOfStock,
                cartBloc: cartBloc,
              );

              final variantId = cartItemOutOfStock.variant.id;

              final finderDeleteButton =
                  find.byKey(CartItemsSectionKeys.deleteButton(variantId));

              await tester.tap(finderDeleteButton);
              await tester.pumpAndSettle();

              // assert RemoveCartItem event is dispatched
              verify(
                () => cartBloc.add(
                  RemoveCartItem(cartItemOutOfStock.variant),
                ),
              ).called(1);
            },
          );
        },
      );
    },
  );
}

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpCartItemTile({
    required CartItemModel item,
    required CartBloc cartBloc,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      BlocProvider.value(
        value: cartBloc,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                ctx = context;
                return CartItemTile(item: item);
              },
            ),
          ),
        ),
      ),
    );

    return ctx;
  }
}
