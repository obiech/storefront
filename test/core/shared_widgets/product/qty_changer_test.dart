import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

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
}
