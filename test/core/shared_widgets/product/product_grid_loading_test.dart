import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

import '../../../commons.dart';

const rows = 2;
const columns = 3;

extension WidgetTesterX on WidgetTester {
  Future<void> pumpProductGridLoading() async {
    await pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProductGridLoading(
            rows: rows,
            columns: columns,
          ),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setUpLocaleInjection();
  });

  testWidgets('Should display a grid of [ProductItemCardLoading]',
      (WidgetTester tester) async {
    await tester.pumpProductGridLoading();

    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byType(ProductItemCardLoading, skipOffstage: false),
      findsNWidgets(columns * rows),
    );
    //
  });
}
