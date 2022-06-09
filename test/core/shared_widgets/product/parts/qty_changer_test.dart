import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../../test_commons/test_commons.dart';

void main() {
  testWidgets('Quantity will never exceed maximum value',
      (WidgetTester tester) async {
    /// arrange
    const quantity = 11;
    const max = 12;

    await tester.pumpQuantityChanger((p0) {}, max, value: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);
    expect(ProductWidgetFinders.incrementButtonFinder, findsOneWidget);

    // Tap increment button 5 times
    for (int i = 0; i < 5; i++) {
      await tester.tap(ProductWidgetFinders.incrementButtonFinder);
      await tester.pumpAndSettle();
    }

    expect(find.text(max.toString()), findsOneWidget);
  });

  testWidgets('Quantity will never go below zero', (WidgetTester tester) async {
    /// arrange
    const quantity = 2;
    const max = 3;

    await tester.pumpQuantityChanger((p0) {}, max, value: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);
    expect(ProductWidgetFinders.decrementButtonFinder, findsOneWidget);

    // Tap increment button 5 times
    for (int i = 0; i < 5; i++) {
      await tester.tap(ProductWidgetFinders.decrementButtonFinder);
      await tester.pumpAndSettle();
    }

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Quantity displayed changes with increment and decrement',
      (WidgetTester tester) async {
    /// arrange
    const quantity = 2;
    const max = 3;

    await tester.pumpQuantityChanger((p0) {}, max, value: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);
    expect(ProductWidgetFinders.decrementButtonFinder, findsOneWidget);

    // Decrement quantity
    await tester.tap(ProductWidgetFinders.decrementButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text((quantity - 1).toString()), findsOneWidget);

    // Increment quantity
    await tester.tap(ProductWidgetFinders.incrementButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(ProductWidgetFinders.incrementButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text((quantity + 1).toString()), findsOneWidget);
  });

  testWidgets('Initial value/quantity can never be below zero',
      (WidgetTester tester) async {
    /// arrange
    const quantity = -5;
    await tester.pumpQuantityChanger((p0) => {}, 2, value: quantity);

    /// act
    expect(find.text(quantity.toString()), findsNothing);
    expect(find.text(0.toString()), findsOneWidget);
  });

  testWidgets('When quantity changes, callback is notified',
      (WidgetTester tester) async {
    /// arrange
    const quantity = 5;
    final callBackResult = [];

    await tester.pumpQuantityChanger(
      (qty) => callBackResult.add(qty),
      20,
      value: quantity,
    );

    /// act
    for (int i = 0; i < 6; i++) {
      if (i % 3 == 0) {
        // Increment
        await tester.tap(ProductWidgetFinders.incrementButtonFinder);
      } else {
        // Decrement
        await tester.tap(ProductWidgetFinders.decrementButtonFinder);
      }
    }

    /// assert
    expect(callBackResult, [6, 5, 4, 5, 4, 3]);
  });

  testWidgets(
      'When increment button is touched & stock is at max, '
      'show snackbar to notify user that stock is exceeded',
      (WidgetTester tester) async {
    /// arrange
    final context = await tester.pumpQuantityChanger((p0) => {}, 2);

    /// act
    await tester.tap(ProductWidgetFinders.incrementButtonFinder);
    await tester.pumpAndSettle();

    /// assert
    expect(
      find.text(context.res.strings.thatIsAllTheStockWeHave),
      findsOneWidget,
    );
  });

  testWidgets(
      'should fire [onMaxAvailableQtyChanged] and disable the increment button '
      'when maximum quantity is reached', (WidgetTester tester) async {
    /// arrange
    final callBackResults = <bool>[];
    const maximumQuantity = 2;
    final context = await tester.pumpQuantityChanger(
      (_) {},
      10,
      maxValue: maximumQuantity,
      onMaxAvailableQtyChanged: (isAtMaxQty) {
        callBackResults.add(isAtMaxQty);
      },
    );

    /// Tap increment till maximum quantity
    expect(ProductWidgetFinders.incrementButtonFinder, findsOneWidget);
    for (int i = 0; i < maximumQuantity; i++) {
      await tester.tap(ProductWidgetFinders.incrementButtonFinder);
      await tester.pumpAndSettle();
    }

    /// Button is Disabled
    final incrementButton = tester.firstWidget<RawMaterialButton>(
      ProductWidgetFinders.incrementButtonFinder,
    );
    expect(incrementButton.fillColor, context.res.colors.grey2);
    expect(find.text(maximumQuantity.toString()), findsOneWidget);

    /// [onMaxAvailableQtyChanged] is fired
    expect(callBackResults, [true]);

    /// When decremented [onMaxAvailableQtyChanged] is fired
    /// with false value
    await tester.tap(ProductWidgetFinders.decrementButtonFinder);
    await tester.pumpAndSettle();

    expect(callBackResults, [true, false]);
  });
}

extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpQuantityChanger(
    Function(int) onQtyChanged,
    int stock, {
    int value = 1,
    int? maxValue,
    Function(bool)? onMaxAvailableQtyChanged,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: SizedBox(
                width: 100,
                height: 30,
                child: QtyChanger(
                  stock: stock,
                  onQtyChanged: onQtyChanged,
                  value: value,
                  maxValue: maxValue,
                  onMaxAvailableQtyChanged: onMaxAvailableQtyChanged,
                ),
              ),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
