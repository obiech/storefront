import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/res/strings/english_strings.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpQuantityChanger(
    Function(int) onQtyChanged,
    int maxValue, {
    int value = 1,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 100,
            height: 30,
            child: QtyChanger(
              maxValue: maxValue,
              onQtyChanged: onQtyChanged,
              value: value,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  final incrementButtonFinder = find.byIcon(DropezyIcons.plus);
  final decrementButtonFinder = find.byIcon(DropezyIcons.minus);

  testWidgets('Quantity will never exceed maximum value',
      (WidgetTester tester) async {
    /// arrange
    const quantity = 11;
    const max = 12;

    await tester.pumpQuantityChanger((p0) {}, max, value: quantity);
    expect(find.text(quantity.toString()), findsOneWidget);
    expect(incrementButtonFinder, findsOneWidget);

    // Tap increment button 5 times
    for (int i = 0; i < 5; i++) {
      await tester.tap(incrementButtonFinder);
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
    expect(decrementButtonFinder, findsOneWidget);

    // Tap increment button 5 times
    for (int i = 0; i < 5; i++) {
      await tester.tap(decrementButtonFinder);
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
    expect(decrementButtonFinder, findsOneWidget);

    // Decrement quantity
    await tester.tap(decrementButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text((quantity - 1).toString()), findsOneWidget);

    // Increment quantity
    await tester.tap(incrementButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text(quantity.toString()), findsOneWidget);

    await tester.tap(incrementButtonFinder);
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
        await tester.tap(incrementButtonFinder);
      } else {
        // Decrement
        await tester.tap(decrementButtonFinder);
      }
    }

    /// assert
    expect(callBackResult, [6, 5, 4, 5, 4, 3]);
  });

  final _strings = EnglishStrings();
  testWidgets(
      'When increment button is touched & stock is at max, '
      'show snackbar to notify user that stock is exceeded',
      (WidgetTester tester) async {
    /// arrange
    await tester.pumpQuantityChanger((p0) => {}, 2, value: 2);

    /// act
    await tester.tap(incrementButtonFinder);
    await tester.pump();

    /// assert
    expect(find.text(_strings.thatIsAllTheStockWeHave), findsOneWidget);
  });
}
