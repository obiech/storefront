import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/home/index.dart';

const rows = 3;
const columns = 4;

extension WidgetTesterX on WidgetTester {
  Future<void> pumpParentLoadingGrid() async {
    await pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ParentLoadingGrid(
            rows: rows,
            columns: columns,
            horizontalSpacing: 16,
            verticalSpacing: 12,
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Should display a grid of [ParentCategoriesItemLoading]',
      (WidgetTester tester) async {
    await tester.pumpParentLoadingGrid();

    expect(find.byType(GridView), findsOneWidget);
    expect(
      find.byType(ParentCategoriesItemLoading, skipOffstage: false),
      findsNWidgets(columns * rows),
    );
    //
  });
}
