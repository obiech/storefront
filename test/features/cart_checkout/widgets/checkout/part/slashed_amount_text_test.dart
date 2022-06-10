import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/cart_checkout/widgets/checkout/cart_checkout.dart';

void main() {
  testWidgets(
    'should display price in Rupiahs with 0dp for whole numbers',
    (WidgetTester tester) async {
      await tester.pumpSlashedAmountText('10800');

      final _textWidget = tester.firstWidget(find.byType(Text)) as Text;

      expect(_textWidget.data, 'Rp 108');
    },
  );

  testWidgets(
    'should display price in Rupiahs with 2dp for cents',
    (WidgetTester tester) async {
      await tester.pumpSlashedAmountText('10800056');

      final _textWidget = tester.firstWidget(find.byType(Text)) as Text;

      expect(_textWidget.data, 'Rp 108.000,56');
    },
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpSlashedAmountText(String discount) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SlashedAmountText(discount: discount),
        ),
      ),
    );
  }
}
